class redis::sentinel(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'stopped',
                            $service_enable        = false,
                            $bind                  = '127.0.0.1',
                            $port                  = '26379',
                          ) inherits redis::params{

  Class['::redis'] ->
  class { '::sentinel::install': } ->
  class { '::sentinel::config': } ~>
  class { '::sentinel::service': } ->
  Class['::redis::sentinel']

}
