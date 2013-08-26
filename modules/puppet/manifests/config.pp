class puppet::config {
  concat::file {
    'main.conf':
      ensure  => present,
      path    => '/etc/puppet/conf.d/main.conf',
      head    => "[main]\n",
      owner   => root,
      group   => root,
      mode    => '0644',
      require => File['/etc/puppet/conf.d'],
      before  => Exec['generate-puppet-conf'];
  }

  concat::fragment {
    'puppet-conf-common-main':
      order   => '01',
      file    => 'main.conf',
      content => template('puppet/puppet-main.conf.erb');
  }

  file {
    '/var/lib/puppet':
      ensure => directory,
      mode   => '0755';

    '/etc/puppet/conf.d':
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0755';
  }

  $generate_command = '/bin/cat `/bin/ls * | /usr/bin/sort -n -t _ -k1`'
  $path = '/etc/puppet/puppet.conf'

  exec {
    'generate-puppet-conf':
      cwd     => '/etc/puppet/conf.d',
      command => "${generate_command} > ${path}",
      unless  => "${generate_command} | cmp ${path}";
  }

}
