class redis::sentinel::config inherits redis::sentinel {

  concat { $redis::params::sentinel_config:
    ensure => 'present',
    owner  => $redis::sentinel::redis_user,
    group  => $redis::sentinel::redis_group,
    mode   => '0644',
  }

  concat::fragment { 'sentinel base config':
    target  => $redis::params::sentinel_config,
    order   => '00',
    content => template("${module_name}/sentinel_base.erb"),
  }

  # systemd::service { "sentinel-${redis_instancename}":
  #   execstart              => "${redis::params::sentinel_bin} /etc/redis/sentinel-${redis_instancename}.conf",
  #   type                   => 'forking',
  #   before                 => Service["sentinel-${redis_instancename}"],
  #   pid_file               => "/var/run/redis-${redis_instancename}/redis.pid",
  #   user                   => $redis_user,
  #   group                  => $redis_group,
  #   runtime_directory      => [ "redis-${redis_instancename}" ],
  #   runtime_directory_mode => '0755',
  # }

}
