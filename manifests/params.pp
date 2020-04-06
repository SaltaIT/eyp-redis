class redis::params {

  $default_redis_user='redis'
  $default_redis_group='redis'


  case $::osfamily
  {
    'redhat':
    {
      $servicename='redis'
      $os_flavor='RH'
      $package_name=[ 'redis' ]
      $sentinel_package=undef
      $sentinel_servicename='redis-sentinel'
      $sentinel_config='/etc/redis-sentinel.conf'
      $default_sentinel_dir = '/tmp'

      $sentinel_pidfile=undef


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
      $package_name=[ 'redis-server', 'redis-tools' ]
      $redisserver_bin='/usr/bin/redis-server'
      $sentinel_package = 'redis-sentinel'
      $sentinel_servicename='redis-sentinel'
      $sentinel_config='/etc/redis/sentinel.conf'
      $default_sentinel_dir = '/var/lib/redis'


      case $::operatingsystem
      {
        'Ubuntu':
        {
          case $::operatingsystemrelease
          {
            /^14.*$/:
            {
              $systemd=false
              $sentinel_pidfile=undef
            }
            /^1[68].*$/:
            {
              $systemd=true
              $sentinel_pidfile='/var/run/redis/redis-sentinel.pid'
            }
            default: { fail("Unsupported Ubuntu version! - ${::operatingsystemrelease}")  }
          }
        }
        'Debian':
        {
          case $::operatingsystemrelease
          {
            /^10\..*$/:
            {
              $systemd=true
              $sentinel_pidfile='/var/run/redis/redis-sentinel.pid'
            }
            default: { fail("Unsupported Debian version! - ${::operatingsystemrelease}")  } 
          }
        }
        default: { fail('Unsupported Debian flavour!')  }
      }
    }
    default: { fail('Unsupported OS!')  }
  }
}
