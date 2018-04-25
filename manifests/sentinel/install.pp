class sentinel::install inherits sentinel {
  if($redis::params::sentinel_bin==undef)
  {
    fail('sentinel not supported')
  }

  if($redis::params::sentinel_package!=undef)
  {
    if($sentinel::manage_package)
    {
      package { $sentinel::params::sentinel_package:
        ensure => $sentinel::package_ensure,
      }
    }
  }
}
