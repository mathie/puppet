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

  concat::fragment {
    'puppet-conf-master':
      file    => 'puppet.conf',
      content => template('puppet/puppet-master.conf.erb');
  }

  $autosign_ensure = $::vagrant ? {
    'true'  => present,
    default => absent,
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
