#!/bin/bash

# Скрипт для настройки проброса портов для Moodle на HQ-SRV

# Проверка наличия Docker
if ! command -v docker >/dev/null; then
    echo "Установка Docker..."
    apt-get update -y
    apt-get install -y docker.io
    systemctl start docker
    systemctl enable docker
fi

# Остановка и удаление существующих контейнеров, если они есть
docker stop moodle moodle_mysql >/dev/null 2>&1
docker rm moodle moodle_mysql >/dev/null 2>&1

# Запуск контейнера MySQL для Moodle
docker run -d --name moodle_mysql \
    --restart=always \
    -e MYSQL_DATABASE=moodle \
    -e MYSQL_USER=moodle \
    -e MYSQL_PASSWORD=moodlepass \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    mysql:5.7

# Запуск контейнера Moodle с пробросом порта 80
docker run -d --name moodle \
    -p 80:80 \
    --restart=always \
    -e MOODLE_DB_HOST=moodle_mysql \
    -e MOODLE_DB_USER=moodle \
    -e MOODLE_DB_PASSWORD=moodlepass \
    -e MOODLE_DB_NAME=moodle \
    moodlehq/moodle-php-apache:latest

# Проверка статуса контейнеров
if docker ps | grep -q moodle && docker ps | grep -q moodle_mysql; then
    echo "Moodle успешно запущен на HQ-SRV с пробросом порта 80."
    echo "Проверьте: http://hq-srv.au-team.irpo"
else
    echo "Ошибка при запуске контейнеров Moodle."
    exit 1
fi
