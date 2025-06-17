#!/bin/bash

# Скрипт для настройки Nginx как обратного прокси на ISP

# Установка Nginx
apt-get update -y
apt-get install -y nginx

# Создание конфигурационного файла для Nginx
cat <<EOF > /etc/nginx/sites-available/proxy.conf
server {
    listen 80;
    server_name moodle.au-team.irpo;

    location / {
        proxy_pass http://hq-srv.au-team.irpo:80;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}

server {
    listen 80;
    server_name wiki.au-team.irpo;

    location / {
        proxy_pass http://br-srv.au-team.irpo:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# Активация конфигурации
ln -sf /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf

# Удаление дефолтной конфигурации, если она есть
rm -f /etc/nginx/sites-enabled/default

# Проверка синтаксиса конфигурации
nginx -t

# Перезапуск Nginx
systemctl restart nginx
systemctl enable nginx

echo "Nginx настроен как обратный прокси на ISP."
