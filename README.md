https://download.yandex.ru/browser/alt-os/yandex-browser.rpm 
  4_M2.sh
        Скрипт создаёт пользователей alice и bob с паролем P@ssw0rd для Samba. Пароль можно изменить, отредактировав строки с smbpasswd.
        Папка /srv/samba/share создаётся с правами 2775, чтобы новые файлы наследовали группу sambashare.
        Если используется UFW, скрипт открывает необходимые порты для Samba.
        Для проверки с клиента (например, HQ-CLI) используй:
        smbclient -L //hq-srv.au-team.irpo -U alice
        или подключись к папке: mount -t cifs //hq-srv.au-team.irpo/share /mnt -o username=alice.

        
