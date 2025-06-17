#!/bin/bash

# Скрипт для установки Docker и развёртывания Moodle на HQ-SRV

# Установка Docker
apt-get update -y
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Запуск контейнера Moodle
docker run -d --name moodle \
    -p 80:80 \
    --restart=always \
    -e MOODLE_DB_HOST=moodle_mysql \
    -e MOODLE_DB_USER=moodle \
    -e MOODLE_DB_PASSWORD=moodlepass \
    -e MOODLE_DB_NAME=moodle \
    moodlehq/moodle-php-apache:latest

# Запуск контейнера MySQL для Moodle
docker run -d --name moodle_mysql \
    --restart=always \
    -e MYSQL_DATABASE=moodle \
    -e MYSQL_USER=moodle \
    -e MYSQL_PASSWORD=moodlepass \
    -e MYSQL_ROOT_PASSWORD=rootpass \
    mysql:5.7

echo "Moodle развёрнут на HQ-SRV. Доступ по порту 80."
echo "Проверьте: http://hq-srv.au-team.irpo"
