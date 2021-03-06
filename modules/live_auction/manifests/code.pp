class live_auction::code($rails_env = 'production') {
  include ssl # For the up to date SSL certificate.
  include libxml::dev, imagemagick::dev, wkhtmltopdf, libicu::dev

  rails::deployment {
    'live_auction':
      ruby_version        => '1.9',
      rails_env           => $rails_env,
      uid                 => 20004,
      git_repo            => 'git@github.com:lionelnierop/Live_Auction.git',
      ssh_private_key     => 'puppet:///modules/live_auction/keys/live-auction-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/live_auction/keys/live-auction-authorized-keys.pub',
      db_type             => 'postgresql';
  }

  Class['libxml::dev']      -> Class['live_auction::code']
  Class['imagemagick::dev'] -> Class['live_auction::code']
  Class['wkhtmltopdf']      -> Class['live_auction::code']
  Class['libicu::dev']      -> Class['live_auction::code']
}
