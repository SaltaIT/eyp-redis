
_osfamily               = fact('osfamily')
_operatingsystem        = fact('operatingsystem')
_operatingsystemrelease = fact('operatingsystemrelease').to_f

case _osfamily
when 'RedHat'
  $sentinel_servicename = 'redis-sentinel'

when 'Debian'
  $sentinel_servicename = 'redis-sentinel'

else
  $examplevar = '-_-'

end
