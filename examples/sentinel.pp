class { 'redis': }

redis::instance { '1111':
  sentinel => true,
}

redis::instance { '1112':
  sentinel => true,
}

redis::instance { '1113':
}

redis::instance { '1114': }

redis::instance { '1115':
  sentinel => true,
  sentinel_group_name => 'testcluster',
}

redis::instance { '1116':
  sentinel => true,
  sentinel_group_name => 'testcluster',
}
