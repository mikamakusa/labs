class roles::docker {
  # Installation du paquet Docker fourni par les dépôts Ubuntu.
  package { 'docker.io':
    ensure => installed,
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker.io'],
  }

  user { 'vagrant':
    groups     => ['docker'],
    membership => 'inclusive',
    require    => Package['docker.io'],
  }
}
