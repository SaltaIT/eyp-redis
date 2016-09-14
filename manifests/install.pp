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

  if($redis::manage_package)
  {
    # package here, for example:
    package { $redis::params::package_name:
      ensure => $redis::package_ensure,
    }
  }

}
