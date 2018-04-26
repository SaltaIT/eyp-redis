class redis (
              $manage_package        = true,
              $package_ensure        = 'installed',
              $manage_service        = true,
              $manage_docker_service = true,
              $service_ensure        = 'stopped',
              $service_enable        = false,
            ) inherits redis::params{

  class { '::redis::install': } ->
  class { '::redis::service': } ->
  Class['::redis']

}
