#!/bin/bash

echo "🚀 Déploiement Multi-Niche AI en production"

# Configuration
DOCKER_REGISTRY="your-registry.com"
IMAGE_NAME="multi-niche-ai"
VERSION=$(git rev-parse --short HEAD)

# Build de l'image
echo "🔨 Build de l'image Docker..."
docker build -t $IMAGE_NAME:$VERSION .
docker tag $IMAGE_NAME:$VERSION $IMAGE_NAME:latest

# Push vers le registry (si configuré)
if [ ! -z "$DOCKER_REGISTRY" ]; then
    echo "📤 Push vers le registry..."
    docker tag $IMAGE_NAME:$VERSION $DOCKER_REGISTRY/$IMAGE_NAME:$VERSION
    docker tag $IMAGE_NAME:latest $DOCKER_REGISTRY/$IMAGE_NAME:latest
    docker push $DOCKER_REGISTRY/$IMAGE_NAME:$VERSION
    docker push $DOCKER_REGISTRY/$IMAGE_NAME:latest
fi

# Déploiement Kubernetes (si configuré)
if command -v kubectl &> /dev/null; then
    echo "☸️ Déploiement Kubernetes..."
    kubectl apply -f deploy/k8s/
    kubectl set image deployment/multi-niche-ai app=$DOCKER_REGISTRY/$IMAGE_NAME:$VERSION
    kubectl rollout status deployment/multi-niche-ai
fi

echo "✅ Déploiement terminé!"