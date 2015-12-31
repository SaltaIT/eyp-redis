# == Class: redis
class redis() inherits redis::params {

  include epel

  package { 'redis':
    ensure  => 'installed',
    require => Class['epel'],
  }

  service { 'redis':
    ensure  => 'running',
    enable  => true,
    require => Package['redis'],
  }

}
