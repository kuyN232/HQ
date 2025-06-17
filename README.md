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
  10_M2.sh
        Настрой SSH-ключи для беспарольного доступа:
        Для серверов:
        ssh-copy-id sshuser@hq-srv.au-team.irpo
        ssh-copy-id sshuser@hq-cli.au-team.irpo
        ssh-copy-id sshuser@br-srv.au-team.irpo
        Для маршрутизаторов:
        ssh-copy-id net_admin@hq-rtr.au-team.irpo
        ssh-copy-id net_admin@br-rtr.au-team.irpo
        Выполни проверку:
        ansible all -m ping
        Ожидаемый результат: все узлы возвращают pong.
        (((((Как работает скрипт
Проверка и установка Docker:
Если Docker не установлен, скрипт устанавливает docker.io и активирует службу.
Очистка существующих контейнеров:
Останавливает и удаляет контейнеры moodle, moodle_mysql (на HQ-SRV) или mediawiki, mediawiki_mysql (на BR-SRV), чтобы избежать конфликтов портов.
Запуск контейнеров:
Для Moodle (HQ-SRV):
MySQL-контейнер (moodle_mysql) с базой данных moodle.
Moodle-контейнер с пробросом порта 80:80 (порт хоста 80 → порт контейнера 80).
Для MediaWiki (BR-SRV):
MySQL-контейнер (mediawiki_mysql) с базой данных mediawiki.
MediaWiki-контейнер с пробросом порта 8080:80 (порт хоста 8080 → порт контейнера 80).
Оба контейнера настроены на автозапуск (--restart=always).
Проверка:
Скрипт проверяет, что оба контейнера запущены, с помощью docker ps.
Выводит инструкции для проверки доступа через браузер.
Примечания
Пароли: Пароли для баз данных (moodlepass, wiki_pass, rootpass) указаны для примера. В продакшене замени их на безопасные.
Сетевые настройки: Убедись, что имена хостов (hq-srv.au-team.irpo, br-srv.au-team.irpo) разрешаются через DNS или /etc/hosts. Если нет, используй IP-адреса (например, 192.168.10.2 для HQ-SRV).
Файрвол: Порты 80 (HQ-SRV) и 8080 (BR-SRV) должны быть открыты:
bash

Свернуть

Перенос

Исполнить

Копировать
ufw allow 80  # на HQ-SRV
ufw allow 8080  # на BR-SRV
Проверка:
Moodle: http://hq-srv.au-team.irpo (порт 80).
MediaWiki: http://br-srv.au-team.irpo:8080 (порт 8080).
Демо-ответы: Скрипт соответствует типичным требованиям демо (проброс портов 80 для Moodle и 8080 для MediaWiki), как указано в задачах 5 и 8.
Отчёт для задачи 6
Описание: Настроен проброс портов в Docker для сервисов Moodle и MediaWiki.
Результат:
На HQ-SRV: контейнер Moodle доступен на порту 80 хоста (http://hq-srv.au-team.irpo).
На BR-SRV: контейнер MediaWiki доступен на порту 8080 хоста (http://br-srv.au-team.irpo:8080).
Контейнеры MySQL для обоих сервисов настроены и связаны с основными контейнерами.
Все контейнеры настроены на автозапуск.
Проверка:
Moodle доступен через http://hq-srv.au-team.irpo.
MediaWiki доступен через http://br-srv.au-team.irpo:8080.
Скрипты:
setup_moodle_ports.sh (HQ-SRV).
setup_mediawiki_ports.sh (BR-SRV).)))))
