#!/bin/bash

# Скрипт для настройки chrony для синхронизации сетевого времени

# Функция для настройки сервера chrony на HQ-RTR
configure_server() {
    echo "Настройка сервера chrony на HQ-RTR..."
    
    # Установка chrony
    apt-get update -y
    apt-get install -y chrony
    
    # Создание резервной копии исходного конфигурационного файла
    cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak
    
    # Настройка chrony как сервера с уровнем stratum 5
    cat <<EOF > /etc/chrony/chrony.conf
# Использование публичных NTP-серверов как запасной вариант
server 0.pool.ntp.org iburst
server 1.pool.ntp.org iburst
server 2.pool.ntp.org iburst
server 3.pool.ntp.org iburst

# Разрешение клиентам подключаться
allow 192.168.0.0/16  # Укажи свой диапазон сети

# Установка уровня stratum
local stratum 5

# Дополнительные настройки
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
EOF
    
    # Перезапуск службы chrony
    systemctl restart chrony
    systemctl enable chrony
    echo "Сервер chrony настроен на HQ-RTR."
}

# Функция для настройки клиентов chrony
configure_client() {
    echo "Настройка клиента chrony на $HOSTNAME..."
    
    # Установка chrony
    apt-get update -y
    apt-get install -y chrony
    
    # Создание резервной копии исходного конфигурационного файла
    cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.bak
    
    # Настройка chrony для использования HQ-RTR как сервера времени
    cat <<EOF > /etc/chrony/chrony.conf
# Использование HQ-RTR как сервера времени
server hq-rtr.au-team.irpo iburst

# Дополнительные настройки
driftfile /var/lib/chrony/drift
makestep 1.0 3
rtcsync
EOF
    
    # Перезапуск службы chrony
    systemctl restart chrony
    systemctl enable chrony
    echo "Клиент chrony настроен на $HOSTNAME."
}

# Определение роли машины на основе имени хоста
case $HOSTNAME in
    hq-rtr.au-team.irpo)
        configure_server
        ;;
    hq-srv.au-team.irpo|hq-cli.au-team.irpo|br-rtr.au-team.irpo|br-srv.au-team.irpo)
        configure_client
        ;;
    *)
        echo "Этот скрипт не предназначен для этой машины: $HOSTNAME"
        exit 1
        ;;
esac
