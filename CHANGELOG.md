# CHANGELOG

## 0.1.6

* Updated validate_* functions to validate_legacy - thanks to [jtreminio](https://github.com/jtreminio) for this [PR-13](https://github.com/NTTCom-MS/eyp-redis/pull/13)

## 0.1.5

* bugfix **redis::instance** service notifications with **daemonize** set to false

## 0.1.4

* added **daemonize** option to **redis::instance**

## 0.1.3

* Ubuntu 16.04 support

## 0.1.2

* added **password** to **redis::instance** to be able to set a global password for redis

## 0.1.1

* added unixsocket, unixsocketperm and listen_tcp to **redis::instance**
* added redis_instancename variable
* improved systemd config
* changed pid file to **/var/run/redis-${redis_instancename}/redis.pid**

## 0.1.0

* initial release
