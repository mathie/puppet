class puppet::master::config {
  include git
  include ssh::client
  include puppet::config

  File {
    ensure => present,
    owner  => puppet,
    group  => puppet,
    mode   => '0644',
  }

  concat::file {
    'master.conf':
      ensure  => present,
      path    => '/etc/puppet/conf.d/master.conf',
      head    => "[master]\n",
      owner   => root,
      group   => root,
      mode    => '0644',
      require => File['/etc/puppet/conf.d'],
      before  => Exec['generate-puppet-conf'];
  }

  concat::fragment {
    'puppet-conf-master':
      file    => 'master.conf',
      content => template('puppet/puppet-master.conf.erb');
  }

  $autosign_ensure = str2bool($::vagrant) ? {
    true  => present,
    false => absent,
  }

  file {
    '/etc/puppet/autosign.conf':
      ensure  => $autosign_ensure,
      content => "*\n";

    '/var/lib/puppet/reports':
      ensure       => directory,
      owner        => puppet,
      group        => puppet,
      mode         => '0750',
      recurse      => true,
      recurselimit => 1;
  }

  anchor { 'puppet::master::config::begin': } ->
    Class['puppet::config'] ->
    anchor { 'puppet::master::config::end': }
}
