https://download.yandex.ru/browser/alt-os/yandex-browser.rpm 
  4_M2.sh
        Скрипт создаёт пользователей alice и bob с паролем P@ssw0rd для Samba. Пароль можно изменить, отредактировав строки с smbpasswd.
        Папка /srv/samba/share создаётся с правами 2775, чтобы новые файлы наследовали группу sambashare.
        Если используется UFW, скрипт открывает необходимые порты для Samba.
        Для проверки с клиента (например, HQ-CLI) используй:
        smbclient -L //hq-srv.au-team.irpo -U alice
        или подключись к папке: mount -t cifs //hq-srv.au-team.irpo/share /mnt -o username=alice.

        
  5_M2.sh
        Убедись, что порты 80 (HQ-SRV) и 8080 (BR-SRV) открыты в файрволе:
        ufw allow 80  # на HQ-SRV
        ufw allow 8080  # на BR-SRV
        Для проверки:
        Moodle: открой http://hq-srv.au-team.irpo в браузере.
        MediaWiki: открой http://br-srv.au-team.irpo:8080 в браузере.
