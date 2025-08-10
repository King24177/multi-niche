.PHONY: help start stop restart logs clean deploy test

help:
	@echo "Multi-Niche AI - Commandes disponibles:"
	@echo ""
	@echo "  start     - Démarrer tous les services"
	@echo "  stop      - Arrêter tous les services"
	@echo "  restart   - Redémarrer tous les services"
	@echo "  logs      - Afficher les logs en temps réel"
	@echo "  monitor   - Monitoring en temps réel"
	@echo "  clean     - Nettoyer les données temporaires"
	@echo "  test      - Lancer les tests"
	@echo "  deploy    - Déployer en production"
	@echo "  backup    - Créer une sauvegarde"

start:
	@chmod +x scripts/start.sh
	@./scripts/start.sh

stop:
	@docker-compose down

restart:
	@docker-compose restart

logs:
	@docker-compose logs -f

monitor:
	@chmod +x scripts/monitor.sh
	@./scripts/monitor.sh --watch

clean:
	@chmod +x scripts/maintenance.sh
	@./scripts/maintenance.sh

test:
	@docker-compose exec app python -m pytest tests/ -v

deploy:
	@chmod +x scripts/deploy.sh
	@./scripts/deploy.sh

backup:
	@mkdir -p backups/$(shell date +%Y%m%d)
	@docker-compose exec postgres pg_dump -U postgres multi_niche_ai > backups/$(shell date +%Y%m%d)/database.sql
	@echo "Sauvegarde créée dans backups/$(shell date +%Y%m%d)/"

# Commandes de développement
dev-setup:
	@cp .env.example .env
	@echo "Configurez vos clés API dans .env puis lancez 'make start'"

dev-shell:
	@docker-compose exec app /bin/bash

dev-db:
	@docker-compose exec postgres psql -U postgres -d multi_niche_ai

# Commandes de collecte
collect-reddit:
	@docker-compose exec app python -m src.collector.reddit_scraper --process-pending

generate-scripts:
	@docker-compose exec app python -m src.generator.script_generator --process-pending

create-videos:
	@docker-compose exec app python -m src.composer.video_builder --process-pending

upload-videos:
	@docker-compose exec app python -m src.publisher.youtube_uploader --process-pending

# Pipeline complet
run-pipeline:
	@echo "🚀 Lancement du pipeline complet..."
	@make collect-reddit
	@sleep 10
	@make generate-scripts
	@sleep 10
	@make create-videos
	@sleep 10
	@make upload-videos
	@echo "✅ Pipeline terminé!"