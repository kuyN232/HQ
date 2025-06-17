#!/bin/bash

# Скрипт для настройки проброса портов для MediaWiki на BR-SRV

# Проверка наличия Docker
if ! command -v docker >/dev/null; then
    echo "Установка Docker..."
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
fi

# Остановка и удаление существующих контейнеров, если они есть
docker stop mediawiki mediawiki_mysql >/dev/null 2>&1
docker rm mediawiki mediawiki_mysql >/dev/null 2>&1

# Запуск контейнера MySQL для MediaWiki
docker run -d --name mediawiki_mysql \
    --restart=always \
    -e MYSQL_DATABASE=mediawiki \
    -e MYSQL_USER=mediawiki \
    -e MYSQL_PASSWORD=wiki_pass \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    mysql:5.7

# Запуск контейнера MediaWiki с пробросом порта 8080
docker run -d --name mediawiki \
    -p 8080:80 \
    --restart=always \
    -e MEDIAWIKI_DB_HOST=mediawiki_mysql \
    -e MEDIAWIKI_DB_USER=mediawiki \
    -e MEDIAWIKI_DB_PASSWORD=wiki_pass \
    -e MEDIAWIKI_DB_NAME=mediawiki \
    mediawiki:latest

# Проверка статуса контейнеров
if docker ps | grep -q mediawiki && docker ps | grep -q mediawiki_mysql; then
    echo "MediaWiki успешно запущен на BR-SRV с пробросом порта 8080."
    echo "Проверьте: http://br-srv.au-team.irpo:8080"
else
    echo "Ошибка при запуске контейнеров MediaWiki."
    exit 1
fi
