# == Class: redis
#
# === redis::install documentation
#
class redis::install inherits redis {

  if($redis::manage_package)
  {
    # package here, for example: 
    #package { $redis::params::package_name:
    #  ensure => $redis::package_ensure,
    #}
  }

}
