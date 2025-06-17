#!/bin/bash

# Скрипт для настройки Samba на HQ-SRV

# Установка Samba
apt-get update -y
apt-get install -y samba

# Создание директории для общей папки
mkdir -p /srv/samba/share
chmod 2775 /srv/samba/share
chown :sambashare /srv/samba/share

# Создание пользователей alice и bob, если они не существуют
id alice >/dev/null 2>&1 || useradd -m -s /bin/bash alice
id bob >/dev/null 2>&1 || useradd -m -s /bin/bash bob

# Установка паролей для Samba
echo -e "P@ssw0rd\nP@ssw0rd" | smbpasswd -s -a alice
echo -e "P@ssw0rd\nP@ssw0rd" | smbpasswd -s -a bob

# Настройка конфигурации Samba
cat <<EOF > /etc/samba/smb.conf
[global]
   workgroup = WORKGROUP
   server string = %h server
   security = user
   map to guest = Bad User

[share]
   path = /srv/samba/share
   writable = yes
   browsable = yes
   valid users = alice, bob
   create mask = 0664
   directory mask = 0775
EOF

# Перезапуск службы Samba
systemctl restart smbd
systemctl enable smbd

# Открытие портов в UFW (если используется)
if command -v ufw >/dev/null; then
    ufw allow Samba
fi

echo "Samba настроена на HQ-SRV. Общая папка: /srv/samba/share. Пользователи: alice, bob."
echo "Для проверки подключения используйте: smbclient -L //hq-srv.au-team.irpo -U alice"
