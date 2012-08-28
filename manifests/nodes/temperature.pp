node 'temperature' {
  include standard
  include postgresql::server

  postgresql::server::user {
    'temperature':
      password => 'xyzzy';
  }

  # To restore the database, get a dump file and do:
  #
  #   sudo -u temperature pg_restore -d temperature -O -c postgresql.dump
  #
  # (ignore the pointless errors about not being able to manipulate the public
  # schema or the plpsql extension language).
  postgresql::server::database {
    'temperature':
      owner => 'temperature';
  }

  rails::deployment {
    'temperature':
      ruby_version        => '1.9',
      uid                 => 20002,
      git_repo            => 'git@github.com:tayeco/temperature.git',
      ssh_private_key     => 'puppet:///modules/users/keys/temperature-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      db_type             => 'postgresql',
      db_password         => 'xyzzy',
      precompile_assets   => false; # No point, no app server for now.
  }

  rails::unicorn {
    'temperature':
      ruby_version => '1.9';
  }

  cron {
    'poll-temperature-service':
      command     => 'cd /u/apps/temperature/current && /usr/bin/ruby1.9.1 -S bundle exec rake poll',
      user        => 'temperature',
      environment => 'RAILS_ENV=production',
      minute      => 15;
  }
}
