class redis::sentinel(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                            $bind                  = '127.0.0.1',
                            $port                  = '26379',
                            $pidfile               = $redis::params::sentinel_pidfile,
                            $redis_user            = $redis::params::default_redis_user,
                            $redis_group           = $redis::params::default_redis_group,
                            $dir                   = $redis::params::default_sentinel_dir,
                          ) inherits redis::params{

  Class['::redis'] ->
  class { '::redis::sentinel::install': } ->
  class { '::redis::sentinel::config': }  ~>
  class { '::redis::sentinel::service': } ->
  Class['::redis::sentinel']

}
