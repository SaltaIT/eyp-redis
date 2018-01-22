class redis::service inherits redis {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  if versioncmp($::puppetversion, '4.0.0') >= 0
  {
    validate_legacy(Boolean, 'validate_bool', $redis::manage_docker_service)
    validate_legacy(Boolean, 'validate_bool', $redis::manage_service)
    validate_legacy(Boolean, 'validate_bool', $redis::service_enable)
    validate_legacy('Optional[String]', 'validate_re', $redis::service_ensure, [ '^running$', '^stopped$' ])
  }
  else
  {
    validate_bool($redis::manage_docker_service)
    validate_bool($redis::manage_service)
    validate_bool($redis::service_enable)
    validate_re($redis::service_ensure, [ '^running$', '^stopped$' ], "Not a valid daemon status: ${redis::service_ensure}")
  }

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $redis::manage_docker_service)
  {
    if($redis::manage_service)
    {
      if($redis::params::systemd)
      {
        if($redis::service_ensure=='stopped')
        {
          if(versioncmp($::puppetversion, '4.2.0')>=0)
          {
            service { $redis::params::servicename:
              ensure => $redis::service_ensure,
              enable => 'mask',
            }
          }
          else
          {
            exec { "systemctl stop and mask ${redis::params::servicename}":
              command => "bash -c 'systemctl stop ${redis::params::servicename}; systemctl mask ${redis::params::servicename}'",
              unless  => "systemctl list-unit-files | grep \"${redis::params::servicename}.service\" | grep masked",
            }
          }
        }
        else
        {
          service { $redis::params::servicename:
            ensure => $redis::service_ensure,
            enable => $redis::service_enable,
          }
        }
      }
      else
      {
        # no systemd
        service { $redis::params::servicename:
          ensure => $redis::service_ensure,
          enable => $redis::service_enable,
        }
      }
    }
  }
}
