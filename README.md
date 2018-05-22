# 1c-enterprise83-client-repack

Скрипт перепаковки deb-пакетов 1С:Предприятия 8.3, который позволит установить несколько версий клиента 1С.

![Скрин 1c-enterprise83-client-repack](/img/menu.png?raw=true "Скрин 1c-enterprise83-client-repack")

Для сборки пакета нужно в папку со скриптом 1c-enterprise83-client-repack.sh положить подпапку с следующими пакетами 1С:Предприятия 8.3 : common, client и server
Т.е. должна получится следующая структура каталогов:

    ├── 1c-enterprise83-client-repack.sh
    ├── 8.3.6-2390
    │   ├── 1c-enterprise83-client_8.3.6-2390_amd64.deb
    │   ├── 1c-enterprise83-common_8.3.6-2390_amd64.deb
    │   └── 1c-enterprise83-server_8.3.6-2390_amd64.deb
    └── 8.3.7-2027
        ├── 1c-enterprise83-client_8.3.7-2027_amd64.deb
        ├── 1c-enterprise83-common_8.3.7-2027_amd64.deb
        └── 1c-enterprise83-server_8.3.7-2027_amd64.deb

Затем нужно запустить скрипт, указав в параметре нужную версию:

    1c-enterprise83-client-repack.sh 8.3.7-2027 amd64

В результате в папке с версией появится пакет типа:
1c-enterprise83-client-repack-8.3.7-2027_amd64.deb
