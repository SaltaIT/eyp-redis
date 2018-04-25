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
