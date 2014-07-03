
# 1c-enterprise83-client-repack

Скрипт перепаковки deb-пакетов 1С:Предприятия 8.3, который позволит установить несколько версий клиента 1С.

![Скрин 1c-enterprise83-client-repack](/img/menu.png?raw=true "Скрин 1c-enterprise83-client-repack")

Для сборки пакета нужно положить в одну папку со скриптом 1c-enterprise83-client-repack.sh
пакеты 1С:Предприятия 8.3 (common, client и server!) например:
1c-enterprise83-common_8.3.5-1033_amd64.deb 
1c-enterprise83-client_8.3.5-1033_amd64.deb
1c-enterprise83-server_8.3.5-1033_amd64.deb 

В результате скрипт создаст пакет:
1c-enterprise83-client-repack-8.3.5-1033_amd64.deb
