define redis::sentinel::instance(
                                  $instance_name           = $name,
                                  $redis_addr              = '127.0.0.1',
                                  $redis_port              = $name,
                                  $redis_password          = undef,
                                  $order                   = '42',
                                  $group_name              = "${name}cluster",
                                  $quorum                  = '2',
                                  $down_after_milliseconds = '5000',
                                  $parallel_syncs          = '1',
                                  $failover_timeout        = '10000',
                                ) {
  include redis::sentinel

  concat::fragment { "sentinel ${instance_name}":
    target  => $redis::params::sentinel_config,
    order   => "01-${order}",
    content => template("${module_name}/sentinel_instance.erb"),
  }
}
