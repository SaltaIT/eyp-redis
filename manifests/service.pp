class redis::service inherits redis {

  #
  validate_bool($redis::manage_docker_service)
  validate_bool($redis::manage_service)
  validate_bool($redis::service_enable)

  validate_re($redis::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${redis::service_ensure}")

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $redis::manage_docker_service)
  {
    if($redis::manage_service)
    {
      #service or exec here
    }
  }
}
