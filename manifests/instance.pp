define redis::instance(
                        $port                             = $name,
                        $redis_instancename               = $name,
                        $bind                             = '0.0.0.0',
                        $timeout                          = '0',
                        $datadir                          = "/var/lib/redis-${name}",
                        $ensure                           = 'running',
                        $manage_service                   = true,
                        $manage_docker_service            = true,
                        $enable                           = true,
                        $redis_user                       = $redis::params::default_redis_user,
                        $redis_group                      = $redis::params::default_redis_group,
                        $unixsocket                       = undef,
                        $unixsocketperm                   = '700',
                        $listen_tcp                       = true,
                        $password                         = undef,
                        $daemonize                        = true,
                        $sentinel                         = false,
                        $sentinel_group_name              = "${name}cluster",
                        $sentinel_quorum                  = '2',
                        $sentinel_down_after_milliseconds = '5000',
                        $sentinel_parallel_syncs          = '1',
                        $sentinel_failover_timeout        = '10000',
                      ) {

  include ::redis

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
    require => [ File["/etc/redis/redis-${redis_instancename}.conf"], Exec["redis datadir ${datadir}"] ],
  }

  file { "/etc/redis/redis-${redis_instancename}.conf":
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Class['::redis'],
    content => template("${module_name}/redisconf.erb"),
    notify  => Service["redis-${redis_instancename}"],
  }

  if($daemonize)
  {
    if($redis::params::systemd)
    {
      include systemd

      if(!defined(File['/usr/bin/redis-shutdown']))
      {
        file { '/usr/bin/redis-shutdown':
          ensure  => 'present',
          owner   => 'root',
          group   => 'root',
          mode    => '0755',
          before  => Service["redis-${redis_instancename}"],
          content => template("${module_name}/initscripts/RH/shutdownredis.erb"),
        }
      }

      systemd::service { "redis-${redis_instancename}":
        execstart              => "${redis::params::redisserver_bin} /etc/redis/redis-${redis_instancename}.conf",
        execstop               => "/usr/bin/redis-shutdown redis-${redis_instancename}",
        type                   => 'forking',
        before                 => Service["redis-${redis_instancename}"],
        pid_file               => "/var/run/redis-${redis_instancename}/redis.pid",
        user                   => $redis_user,
        group                  => $redis_group,
        runtime_directory      => [ "redis-${redis_instancename}" ],
        runtime_directory_mode => '0755',
      }
    }
    else
    {
      file { "/etc/init.d/redis-${name}":
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
        before  => Service["redis-${redis_instancename}"],
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
        service { "redis-${redis_instancename}":
          ensure    => $ensure,
          enable    => $enable,
          subscribe => File["/etc/redis/redis-${redis_instancename}.conf"],
        }
      }
    }

    if($sentinel)
    {
      redis::sentinel::instance { "sentinel-${redis_instancename}":
        instance_name           => $redis_instancename,
        redis_port              => $port,
        redis_password          => $password,
        group_name              => $sentinel_group_name,
        quorum                  => $sentinel_quorum,
        down_after_milliseconds => $sentinel_down_after_milliseconds,
        parallel_syncs          => $sentinel_parallel_syncs,
        failover_timeout        => $sentinel_failover_timeout,
      }
    }
  }
}
