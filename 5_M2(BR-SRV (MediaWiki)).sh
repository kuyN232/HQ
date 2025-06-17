#!/bin/bash

# Скрипт для установки Docker и развёртывания MediaWiki на BR-SRV

# Установка Docker
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Запуск контейнера MediaWiki
docker run -d --name mediawiki \
    -p 8080:80 \
    --restart=always \
    -e MEDIAWIKI_DB_HOST=mediawiki_mysql \
    -e MEDIAWIKI_DB_USER=mediawiki \
    -e MEDIAWIKI_DB_PASSWORD=wiki_pass \
    -e MEDIAWIKI_DB_NAME=mediawiki \
    mediawiki:latest

# Запуск контейнера MySQL для MediaWiki
docker run -d --name mediawiki_mysql \
    --restart=always \
    -e MYSQL_DATABASE=mediawiki \
    -e MYSQL_USER=mediawiki \
    -e MYSQL_PASSWORD=wiki_pass \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    mysql:5.7

echo "MediaWiki развёрнут на BR-SRV. Доступ по порту 8080."
echo "Проверьте: http://br-srv.au-team.irpo:8080"
