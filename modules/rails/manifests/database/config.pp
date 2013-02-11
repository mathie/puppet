define rails::database::config($path, $owner = $name, $group = $name, $app = $name, $rails_env = 'production') {
  concat::file {
    "rails-database-${app}_${rails_env}":
      path  => $path,
      owner => $owner,
      group => $group,
      mode  => '0644';
  }

  Rails::Database::Stanza <<| app == $app and rails_env == $rails_env |>>
}
