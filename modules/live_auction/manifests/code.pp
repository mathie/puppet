class live_auction::code($database, $db_host, $db_username, $db_password, $rails_env = 'production') {
  include ssl # For the up to date SSL certificate.
  include libxml::dev, imagemagick::dev, wkhtmltopdf

  rails::deployment {
    'live_auction':
      ruby_version        => '1.9',
      rails_env           => $rails_env,
      uid                 => 20004,
      git_repo            => 'git@github.com:lionelnierop/Live_Auction.git',
      ssh_private_key     => 'puppet:///modules/live_auction/keys/live-auction-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      database            => $database,
      db_type             => 'postgresql',
      db_host             => $db_host,
      db_username         => $db_username,
      db_password         => $db_password;
  }

  Class['libxml::dev']      -> Class['live_auction::code']
  Class['imagemagick::dev'] -> Class['live_auction::code']
  Class['wkhtmltopdf']      -> Class['live_auction::code']
}
