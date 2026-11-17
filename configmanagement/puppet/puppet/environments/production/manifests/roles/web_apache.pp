class roles::web_apache {
  package { 'apache2':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<h1>Serveur Apache géré par Puppet</h1>\n",
    require => Package['apache2'],
  }

  service { 'apache2':
    ensure    => running,
    enable    => true,
    subscribe => File['/var/www/html/index.html'],
    require   => Package['apache2'],
  }
}
