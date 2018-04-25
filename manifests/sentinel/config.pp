class sentinel::config inherits sentinel {
  if($redis::params::sentinel_bin==undef)
  {
    fail('sentinel not supported')
  }

  concat { '/etc/redis/sentinel.conf':
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  concat::fragment { 'sentinel base config':
    target  => '/etc/redis/sentinel.conf',
    order   => '00',
    content => template("${module_name}/sentinel.erb"),
  }

  systemd::service { "sentinel-${redis_instancename}":
    execstart              => "${redis::params::sentinel_bin} /etc/redis/sentinel-${redis_instancename}.conf",
    type                   => 'forking',
    before                 => Service["sentinel-${redis_instancename}"],
    pid_file               => "/var/run/redis-${redis_instancename}/redis.pid",
    user                   => $redis_user,
    group                  => $redis_group,
    runtime_directory      => [ "redis-${redis_instancename}" ],
    runtime_directory_mode => '0755',
  }

}
