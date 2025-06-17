#!/bin/bash

# Скрипт для настройки chrony на сервере и клиентах

# Определение роли машины
HOSTNAME=$(hostname)

if [ "$HOSTNAME" = "hq-rtr.au-team.irpo" ]; then
    # Настройка сервера chrony на HQ-RTR
    apt-get update -y
    apt-get install -y chrony

    # Создание конфигурации для сервера
    cat <<EOF > /etc/chrony/chrony.conf
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst
allow 192.168.0.0/16
allow 10.0.0.0/8
local stratum 5
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
EOF

    systemctl restart chrony
    systemctl enable chrony
    echo "Сервер chrony настроен на HQ-RTR."

else
    # Настройка клиента chrony на HQ-SRV, HQ-CLI, BR-RTR, BR-SRV
    apt-get update -y
    apt-get install -y chrony

    # Создание конфигурации для клиента
    cat <<EOF > /etc/chrony/chrony.conf
server hq-rtr.au-team.irpo iburst
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
EOF

    systemctl restart chrony
    systemctl enable chrony
    echo "Клиент chrony настроен на $HOSTNAME."
fi
