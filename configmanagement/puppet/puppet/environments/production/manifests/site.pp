# Affectation des rôles selon le certname du noeud.
node 'puppet-agent-01.lab.local' {
  include roles::web_nginx
}

node 'puppet-agent-02.lab.local' {
  include roles::web_apache
}

node 'puppet-agent-03.lab.local' {
  include roles::database
}

node 'puppet-agent-04.lab.local' {
  include roles::docker
}

node 'puppet-agent-05.lab.local' {
  include roles::linux
}

# Le master n'est volontairement pas géré par les rôles applicatifs.
node 'puppet-master.lab.local' {
  notify { 'Puppet master managed by Puppet': }
}

# Rôle de secours pour tout nouvel agent du laboratoire.
node default {
  include roles::linux
}
