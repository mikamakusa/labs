class roles::web_nginx {
  package { 'nginx':
    ensure => installed,
  }

  file { '/var/www/html/index.html':
    ensure  => file,
    content => "<h1>Serveur Nginx géré par Puppet</h1>\n",
    require => Package['nginx'],
  }

  service { 'nginx':
    ensure    => running,
    enable    => true,
    subscribe => File['/var/www/html/index.html'],
    require   => Package['nginx'],
  }
}
