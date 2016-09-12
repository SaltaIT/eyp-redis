define redis::instance(
                        $port = $name
                      ) {

  if($redis::params::systemd)
  {
    # include systemd
    #
    # systemd::service { $instancename:
    #   execstart => "/etc/init.d/${instancename} start",
    #   execstop  => "/etc/init.d/${instancename} stop",
    #   require   => File["/etc/init.d/${instancename}"],
    #   before    => Service[$redis::params::servicename],
    #   forking   => true,
    #   restart   => 'no',
    #   user      => 'tomcat',
    #   group     => 'tomcat',
    # }
  }
}
