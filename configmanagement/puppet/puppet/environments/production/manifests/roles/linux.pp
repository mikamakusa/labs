class roles::linux {
  package { ['vim', 'curl', 'htop', 'tree', 'unzip']:
    ensure => installed,
  }

  file { '/etc/motd':
    ensure  => file,
    content => "Machine administrée par Puppet\nEnvironnement : production\n",
  }

  user { 'opsuser':
    ensure     => present,
    comment    => 'Compte de test géré par Puppet',
    managehome => true,
    shell      => '/bin/bash',
  }

  file { '/etc/ssh/sshd_config.d/99-puppet-lab.conf':
    ensure  => file,
    content => "PasswordAuthentication yes\n",
    notify  => Service['ssh'],
  }

  service { 'ssh':
    ensure => running,
    enable => true,
  }
}
