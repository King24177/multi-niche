# 🚀 Quick Start - Multi-Niche AI

## Installation Express (5 minutes)

### 1. Prérequis
```bash
# Vérifier Docker
docker --version
docker-compose --version
```

### 2. Cloner et configurer
```bash
git clone https://github.com/votre-username/multi-niche-ai.git
cd multi-niche-ai
make dev-setup
```

### 3. Configurer les API (.env)
```bash
# Éditer .env avec vos clés :
REDDIT_CLIENT_ID=your_reddit_id
OPENAI_API_KEY=sk-your_openai_key
ELEVENLABS_API_KEY=your_elevenlabs_key
# ... autres clés
```

### 4. Démarrer
```bash
make start
```

### 5. Tester
```bash
# Premier test de collecte
make collect-reddit

# Pipeline complet
make run-pipeline
```

## 📊 Monitoring

- **Application**: http://localhost:8000
- **Workers**: http://localhost:5555  
- **Analytics**: http://localhost:3000
- **Logs**: `make logs`
- **Monitoring**: `make monitor`

## ⚡ Commandes Essentielles

```bash
make start          # Démarrer tout
make stop           # Arrêter tout
make logs           # Voir les logs
make monitor        # Monitoring temps réel
make run-pipeline   # Pipeline complet
make clean          # Nettoyer
make backup         # Sauvegarder
```

## 🔧 Développement

```bash
make dev-shell      # Shell dans le container
make dev-db         # Accès base de données
make test           # Lancer les tests
```

## 🎯 Workflow Typique

1. **Collecte**: `make collect-reddit`
2. **Génération**: `make generate-scripts`  
3. **Création**: `make create-videos`
4. **Publication**: `make upload-videos`

Ou tout en une fois: `make run-pipeline`

## 📞 Support

- Issues: GitHub Issues
- Logs: `make logs`
- Monitoring: `make monitor`