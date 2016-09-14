# == Class: redis
#
# === redis::install documentation
#
class redis::install inherits redis {

  file { '/etc/redis':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if($redis::params::os_flavor=='RH')
  {
    include ::epel

    Package['epel-release'] -> Package[$redis::params::package_name]
  }

  if($redis::manage_package)
  {
    # package here, for example:
    package { $redis::params::package_name:
      ensure => $redis::package_ensure,
    }
  }

}
