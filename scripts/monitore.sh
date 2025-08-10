#!/bin/bash

echo "📊 Monitoring Multi-Niche AI"
echo "============================"

# Fonction pour afficher les métriques
show_metrics() {
    echo "🔢 Métriques système:"
    echo "Containers actifs: $(docker-compose ps | grep -c "Up")"
    echo "CPU usage: $(docker stats --no-stream --format "table {{.CPUPerc}}" | tail -n +2 | head -1)"
    echo "RAM usage: $(docker stats --no-stream --format "table {{.MemPerc}}" | tail -n +2 | head -1)"
    
    echo ""
    echo "📈 Métriques application:"
    
    # Connexion à la base pour récupérer les stats
    STATS=$(docker-compose exec -T postgres psql -U postgres -d multi_niche_ai -t -c "
        SELECT 
            (SELECT COUNT(*) FROM reddit_posts WHERE processing_status = 'pending') as pending_posts,
            (SELECT COUNT(*) FROM generated_scripts WHERE processing_status = 'pending') as pending_scripts,
            (SELECT COUNT(*) FROM video_files WHERE processing_status = 'completed') as ready_videos,
            (SELECT COUNT(*) FROM upload_records WHERE upload_status = 'completed' AND uploaded_at > NOW() - INTERVAL '24 hours') as daily_uploads;
    ")
    
    echo "Posts Reddit en attente: $(echo $STATS | awk '{print $1}')"
    echo "Scripts en attente: $(echo $STATS | awk '{print $2}')"
    echo "Vidéos prêtes: $(echo $STATS | awk '{print $3}')"
    echo "Uploads aujourd'hui: $(echo $STATS | awk '{print $4}')"
}

# Fonction pour afficher les erreurs récentes
show_errors() {
    echo ""
    echo "🚨 Erreurs récentes:"
    docker-compose logs --tail=20 | grep -i error | tail -5
}

# Fonction pour afficher l'état des queues
show_queues() {
    echo ""
    echo "📋 État des queues:"
    docker-compose exec -T redis redis-cli llen collector > /dev/null 2>&1 && echo "Queue collector: $(docker-compose exec -T redis redis-cli llen collector)"
    docker-compose exec -T redis redis-cli llen generator > /dev/null 2>&1 && echo "Queue generator: $(docker-compose exec -T redis redis-cli llen generator)"
    docker-compose exec -T redis redis-cli llen composer > /dev/null 2>&1 && echo "Queue composer: $(docker-compose exec -T redis redis-cli llen composer)"
}

# Mode interactif ou une fois
if [ "$1" = "--watch" ]; then
    while true; do
        clear
        echo "$(date)"
        show_metrics
        show_queues
        show_errors
        echo ""
        echo "Actualisation dans 30 secondes... (Ctrl+C pour arrêter)"
        sleep 30
    done
else
    show_metrics
    show_queues
    show_errors
fi