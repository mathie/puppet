class temperature {
  include postgresql::server

  # To restore the database, get a dump file and do:
  #
  #   sudo -u temperature pg_restore -d temperature -O -c postgresql.dump
  #
  # (ignore the pointless errors about not being able to manipulate the public
  # schema or the plpsql extension language).
  rails::database {
    'temperature':
      db_type     => 'postgresql',
      db_password => 'xyzzy';
  }

  rails::deployment {
    'temperature':
      ruby_version        => '1.9',
      uid                 => 20002,
      git_repo            => 'git@github.com:tayeco/temperature.git',
      ssh_private_key     => 'puppet:///modules/users/keys/temperature-deploy.keys',
      ssh_authorized_keys => 'puppet:///modules/users/keys/mathie.keys.pub',
      db_type             => 'postgresql',
      precompile_assets   => false; # No point, no app server for now.
  }

  cron {
    'poll-temperature-service':
      command     => 'cd /u/apps/temperature/current && /usr/bin/ruby1.9.1 -S bundle exec rake poll > /u/apps/temperature/shared/log/cron-poll.log 2>&1',
      user        => 'temperature',
      environment => [
        'RAILS_ENV=production',
        'PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games',
      ],
      minute      => 15;
  }
}
