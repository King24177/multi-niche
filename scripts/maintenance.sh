#!/bin/bash

echo "🔧 Maintenance Multi-Niche AI"
echo "============================="

# Nettoyage des fichiers temporaires
echo "🧹 Nettoyage des fichiers temporaires..."
find data/ -name "*.tmp" -delete
find data/ -name ".DS_Store" -delete

# Nettoyage des anciens fichiers (> 30 jours)
echo "🗑️  Suppression des anciens fichiers..."
find data/videos/ -type f -mtime +30 -delete
find data/audio/ -type f -mtime +30 -delete
find logs/ -type f -mtime +7 -delete

# Optimisation base de données
echo "🗄️ Optimisation base de données..."
docker-compose exec postgres psql -U postgres -d multi_niche_ai -c "VACUUM ANALYZE;"

# Restart des workers si nécessaire
echo "🔄 Redémarrage des workers..."
docker-compose restart collector-worker generator-worker composer-worker

# Vérification de l'espace disque
echo "💾 Vérification espace disque..."
df -h | grep -E "(data|logs)"

# Sauvegarde quotidienne
echo "💾 Sauvegarde..."
mkdir -p backups/$(date +%Y%m%d)
docker-compose exec postgres pg_dump -U postgres multi_niche_ai > backups/$(date +%Y%m%d)/database.sql

echo "✅ Maintenance terminée!"
