class redis::sentinel::install inherits redis::sentinel {

  if($redis::params::sentinel_package!=undef)
  {
    if($redis::sentinel::manage_package)
    {
      package { $redis::params::sentinel_package:
        ensure => $redis::sentinel::package_ensure,
      }
    }
  }
}
