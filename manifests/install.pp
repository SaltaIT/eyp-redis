class redis::install inherits redis {

  file { '/etc/redis':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if($redis::params::os_flavor=='RH')
  {
    if($redis::manage_package)
    {
      include ::epel

      Class['::epel'] -> Package[$redis::params::package_name]
    }
  }

  if($redis::manage_package)
  {
    package { $redis::params::package_name:
      ensure => $redis::package_ensure,
    }
  }

}
