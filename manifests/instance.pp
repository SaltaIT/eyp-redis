define redis::instance(
                        $port                  = $name,
                        $bind                  = '0.0.0.0',
                        $timeout               = '0',
                        $datadir               = "/var/lib/redis-${name}",
                        $ensure                = 'running',
                        $manage_service        = true,
                        $manage_docker_service = true,
                        $enable                = true,
                        $redis_user            = $redis::params::default_redis_user,
                        $redis_group           = $redis::params::default_redis_group,
                      ) {

  Exec {
    path => '/usr/sbin:/usr/bin:/sbin:/bin',
  }

  #dir /var/lib/redis-<%= @name %>
  exec { "redis datadir ${datadir}":
    command => "mkdir -p ${datadir}",
    creates => $datadir,
  }

  file { $datadir:
    ensure  => 'directory',
    owner   => $redis_user,
    group   => $redis_group,
    mode    => '0755',
    require => [ File["/etc/redis/redis-${name}.conf"], Exec["redis datadir ${datadir}"] ],
  }

  file { "/etc/redis/redis-${name}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => File['/etc/redis'],
    content => template("${module_name}/redisconf.erb"),
  }

  if($redis::params::systemd)
  {
    include systemd

    systemd::service { "redis-${name}":
      execstart => "/etc/init.d/${instancename} start",
      execstop  => "/etc/init.d/${instancename} stop",
      require   => File["/etc/init.d/${instancename}"],
      before    => Service["redis-${name}"],
      forking   => true,
      restart   => 'no',
      user      => 'tomcat',
      group     => 'tomcat',
    }
  }
  else
  {
    file { "/etc/init.d/redis-${name}":
      ensure  => 'present',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      before  => Service["redis-${name}"],
      content => template("${module_name}/initscripts/${redis::params::os_flavor}/init.erb"),
    }
  }

  $is_docker_container_var=getvar('::eyp_docker_iscontainer')
  $is_docker_container=str2bool($is_docker_container_var)

  if( $is_docker_container==false or
      $manage_docker_service)
  {
    if($manage_service)
    {
      service { "redis-${name}":
        ensure  => $ensure,
        enable  => $enable,
      }
    }
  }


}
