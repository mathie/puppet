class itison::code($rails_env = 'production') {

  # Third party binaries, etc, required.
  include geoip, ssl, imagemagick

  # Libraries required to build ruby gems.
  include libxml::dev, geoip::dev

  package {
    'rubygems-update':
      ensure   => '1.4.1',
      provider => 'gem18';
  }

  exec {
    'install-rubygems-141':
      command => '/usr/local/bin/update_rubygems',
      unless  => '/usr/bin/gem1.8 --version | /bin/grep ^1.4.1$',
      require => Package['rubygems-update'];
  }

  Exec['install-rubygems-141'] -> Package['bundler']

  rails::deployment {
    'itison':
      uid                 => 20001,
      git_repo            => 'git@github.com:dadaevents/itison.git',
      git_branch          => 'puppet-production',
      ssh_private_key     => 'puppet:///modules/users/keys/itison.keys',
      ssh_authorized_keys => 'puppet:///modules/itison/authorized_keys',
      ruby_version        => '1.8',
      rails_env           => $rails_env,
      asset_compiler      => 'java',
      db_type             => 'mysql';
  }

  Class['geoip']        -> Rails::Deployment['itison']
  Class['geoip::dev']   -> Rails::Deployment['itison']
  Class['libxml::dev']  -> Rails::Deployment['itison']

  anchor { 'itison::code::begin': } ->
    Rails::Deployment['itison'] ->
    anchor { 'itison::code::end': }
}
