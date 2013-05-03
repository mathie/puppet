class puppet::config {
  concat::file {
    'puppet.conf':
      ensure => present,
      path   => '/etc/puppet/puppet.conf',
      owner  => root,
      group  => root,
      mode   => '0644';
  }

  concat::fragment {
    'puppet-conf-main':
      order   => '01',
      file    => 'puppet.conf',
      content => template('puppet/puppet-main.conf.erb');
  }

  file {
    '/var/lib/puppet':
      ensure => directory,
      mode   => '0755';
  }
}
