#!/bin/bash

# Скрипт для настройки Ansible на BR-SRV

# Установка Ansible
apt-get update -y
apt-get install -y software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt-get install -y ansible

# Создание файла инвентаря
mkdir -p /etc/ansible
cat <<EOF > /etc/ansible/hosts
[servers]
hq-srv.au-team.irpo
hq-cli.au-team.irpo
br-srv.au-team.irpo

[routers]
hq-rtr.au-team.irpo
br-rtr.au-team.irpo

[servers:vars]
ansible_user=sshuser

[routers:vars]
ansible_user=net_admin
EOF

echo "Ansible установлен, файл инвентаря создан: /etc/ansible/hosts."
echo "Настройте SSH-ключи для пользователей sshuser (servers) и net_admin (routers)."
echo "Проверьте подключение: ansible all -m ping"
