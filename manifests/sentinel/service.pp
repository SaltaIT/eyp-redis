class redis::sentinel::service inherits redis::sentinel {

  #
  validate_bool($redis::sentinel::manage_docker_service)
  validate_bool($redis::sentinel::manage_service)
  validate_bool($redis::sentinel::service_enable)

  validate_re($redis::sentinel::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${redis::sentinel::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $redis::sentinel::manage_docker_service)
  {
    if($redis::sentinel::manage_service)
    {
      service { $redis::params::sentinel_servicename:
        ensure => $redis::sentinel::service_ensure,
        enable => $redis::sentinel::service_enable,
      }
    }
  }
}
