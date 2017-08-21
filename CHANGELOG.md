# CHANGELOG

## 0.1.2

* added **password** to **redis::instance** to be able to set a global password for redis

## 0.1.1

* added unixsocket, unixsocketperm and listen_tcp to **redis::instance**
* added redis_instancename variable
* improved systemd config
* changed pid file to **/var/run/redis-${redis_instancename}/redis.pid**

## 0.1.0

* initial release
