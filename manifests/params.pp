class redis::params {

  $default_redis_user='redis'
  $default_redis_group='redis'

  case $::osfamily
  {
    'redhat':
    {
      $servicename='redis'
      $os_flavor='RH'
      case $::operatingsystemrelease
      {
        /^[5-6].*$/:
        {
          $systemd=false
          $redisserver_bin='/usr/sbin/redis-server'
        }
        /^7.*$/:
        {
          $systemd=true
          $redisserver_bin='/usr/bin/redis-server'
        }
        default: { fail("Unsupported RHEL/CentOS version! - ${::operatingsystemrelease}")  }
      }
    }
    'Debian':
    {
      $servicename='redis-server'
      $os_flavor='Debian'
      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $systemd=false
              $redisserver_bin='/usr/bin/redis-server'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian': { fail('Unsupported')  }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
