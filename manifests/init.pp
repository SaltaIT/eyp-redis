# == Class: redis
#
# === redis documentation
#
class redis(
                            $manage_package        = true,
                            $package_ensure        = 'installed',
                            $manage_service        = true,
                            $manage_docker_service = true,
                            $service_ensure        = 'running',
                            $service_enable        = true,
                          ) inherits redis::params{

  class { '::redis::install': } ->
  Class['::redis']

}
