#!/bin/bash

echo "🚀 Démarrage Multi-Niche AI Content Automation"

# Vérification des variables d'environnement
if [ ! -f .env ]; then
    echo "❌ Fichier .env non trouvé. Copiez .env.example vers .env et configurez vos clés API."
    exit 1
fi

# Source des variables
export $(cat .env | grep -v '^#' | xargs)

# Vérification des clés API critiques
REQUIRED_VARS=("REDDIT_CLIENT_ID" "OPENAI_API_KEY" "ELEVENLABS_API_KEY")

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        echo "❌ Variable d'environnement manquante: $var"
        exit 1
    fi
done

echo "✅ Configuration validée"

# Démarrage des services
echo "🐳 Démarrage des containers Docker..."
docker-compose up --build -d

# Attente que les services soient prêts
echo "⏳ Attente des services..."
sleep 30

# Initialisation de la base de données
echo "🗄️ Initialisation de la base de données..."
docker-compose exec app python -m src.core.database --init

# Vérification de l'état des services
echo "🔍 Vérification des services..."
docker-compose ps

echo "✅ Multi-Niche AI démarré avec succès!"
echo ""
echo "📊 Accès aux services:"
echo "   - Application: http://localhost:8000"
echo "   - Flower (monitoring): http://localhost:5555"
echo "   - Grafana (analytics): http://localhost:3000"
echo ""
echo "📝 Logs en temps réel:"
echo "   docker-compose logs -f"