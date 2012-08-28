node 'temperature' {
  include standard
  include postgresql::server

  postgresql::server::user {
    'temperature':
      password => 'xyzzy';
  }

  postgresql::server::database {
    'temperature':
      owner => 'temperature';
  }

  rails::deployment {
    'temperature':
      uid                 => 20002,
      git_repo            => 'git@github.com:tayeco/temperature.git',
      ssh_private_key     => 'puppet:///modules/users/keys/temperature-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      db_type             => 'postgresql',
      db_password         => 'xyzzy',
      precompile_assets   => false; # No point, no app server for now.
  }

  cron {
    'poll-temperature-service':
      command     => 'cd /u/apps/temperature/current && /usr/bin/ruby1.9.1 -S bundle exec rake poll',
      user        => 'temperature',
      environment => 'RAILS_ENV=production',
      minute      => 15;
  }
}
