FROM python:3.11-slim

# Métadonnées
LABEL maintainer="Multi-Niche AI Team"
LABEL description="Système d'automatisation de contenu viral multi-niches"
LABEL version="1.0.0"

# Variables d'environnement
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Installation des dépendances système
RUN apt-get update && apt-get install -y \
    ffmpeg \
    ffprobe \
    curl \
    wget \
    git \
    build-essential \
    pkg-config \
    libffi-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Création du répertoire de travail
WORKDIR /app

# Copie des fichiers de dépendances
COPY requirements.txt .
COPY setup.py .

# Installation des dépendances Python
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copie du code source
COPY . .

# Création des répertoires nécessaires
RUN mkdir -p /app/data/{raw,processed,audio,videos,backgrounds,subtitles} && \
    mkdir -p /app/credentials/{youtube,tiktok} && \
    mkdir -p /app/logs && \
    mkdir -p /app/assets/{templates,fonts,music,images}

# Installation du package
RUN pip install -e .

# Permissions
RUN chmod +x scripts/*.sh || true

# Port par défaut
EXPOSE 8000

# Commande par défaut
CMD ["python", "-m", "src.core.app"]