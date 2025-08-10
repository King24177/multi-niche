#!/bin/bash

echo "⚡ Quick Start - Multi-Niche AI"
echo "================================"

# Vérification de Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose n'est pas installé. Veuillez l'installer d'abord."
    exit 1
fi

# Configuration initiale
if [ ! -f .env ]; then
    echo "📝 Création du fichier de configuration..."
    cp .env.example .env
    echo "⚠️  IMPORTANT: Éditez le fichier .env avec vos clés API avant de continuer."
    echo "📖 Consultez le README.md pour obtenir les clés API nécessaires."
    
    # Ouverture automatique du fichier (si éditeur disponible)
    if command -v code &> /dev/null; then
        code .env
    elif command -v nano &> /dev/null; then
        nano .env
    else
        echo "Éditez manuellement le fichier .env"
    fi
    
    read -p "Appuyez sur Entrée une fois les clés API configurées..."
fi

# Création des dossiers
echo "📁 Création des dossiers..."
mkdir -p data/{raw,processed,audio,videos,backgrounds,subtitles}
mkdir -p credentials/{youtube,tiktok}
mkdir -p logs
mkdir -p assets/{templates,fonts,music,images}

# Démarrage des services
echo "🚀 Démarrage des services..."
docker-compose up --build -d

echo "⏳ Initialisation (30 secondes)..."
sleep 30

# Test de connectivité
echo "🔍 Test des services..."
if curl -f http://localhost:8000/health > /dev/null 2>&1; then
    echo "✅ Application démarrée avec succès!"
else
    echo "⚠️  Application en cours de démarrage..."
fi

# Premier test de collecte
echo "🧪 Test de collecte Reddit..."
docker-compose exec -T app python -m src.collector.reddit_scraper --subreddit "AskReddit" --limit 5

echo "✅ Configuration terminée!"
echo ""
echo "🎯 Prochaines étapes:"
echo "1. Vérifiez les logs: docker-compose logs -f"
echo "2. Accédez au dashboard: http://localhost:3000"
echo "3. Surveillez les workers: http://localhost:5555"
echo "4. Lancez votre première collecte complète:"
echo "   docker-compose exec app python -m src.collector.reddit_scraper --process-pending"

