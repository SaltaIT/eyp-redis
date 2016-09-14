# redis

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What redis affects](#what-redis-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with redis](#beginning-with-redis)
4. [Usage](#usage)
5. [Reference](#reference)
5. [Limitations](#limitations)
6. [Development](#development)
    * [TODO](#todo)
    * [Contributing](#contributing)

## Overview

multi instance redis

## Module Description

This module manages redis instances.

## Setup

### What redis affects

* manages redis package
* disables default redis service, on CentOS 7 also masks the systemd service
* manages as many services as redis instances

### Setup Requirements

* This module requires **pluginsync enabled**.
* **eyp/systemd** is required, but it's only used on **CentOS 7**

### Beginning with redis

```puppet
class { 'redis': }

redis::instance { '6666':
}
```

## Usage

class redis, by default, installs redis and disables the default redis service:

```puppet
class { 'redis': }
```

using redis::instance you can create as many instances as needed on a sigle host:

```puppet
redis::instance { '6666':
}

redis::instance { '6667':
}
```

also:

```puppet
redis::instance { 'instance_A':
  port => '6666',
}

redis::instance { 'instance_B':
  port => '6667',
}
```

## Reference

### classes

#### redis

* **manage_package**:        = true,
* **package_ensure**:        = 'installed',
* **manage_service**:        = true,
* **manage_docker_service**: = true,
* **service_ensure**:        = 'stopped',
* **service_enable**:        = false,

### defines

#### redis::instance

* redis related variables:
  * **port**: port to listen to (default: resource's name)
  * **bind**: bind address (default: 0.0.0.0)
  * **timeout**: (default: 0)
  * **datadir**: redis datadir (default: /var/lib/redis-${name})
  * **redis_user**: redis username (default: redis)
  * **redis_group**: redis group (default: redis)
* package and service related variables:
  * **ensure**:                = 'running',
  * **manage_service**:        = true,
  * **manage_docker_service**: = true,
  * **enable**:                = true,

## Limitations

Tested on:
* CentOS 5
* CentOS 6
* CentOS 7
* Ubuntu 14.04

## Development

We are pushing to have acceptance testing in place, so any new feature should
have some test to check both presence and absence of any feature

### TODO

TODO list

### Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
