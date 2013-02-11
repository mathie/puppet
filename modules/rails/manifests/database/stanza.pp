define rails::database::stanza($stanza_title, $db_type, $app, $database, $hostname, $username, $password, $rails_env, $order = 50) {
  concat::fragment {
    "rails-database-stanza-${name}":
      file    => "rails-database-${app}_${rails_env}",
      order   => $order,
      content => template('rails/database-stanza.yml.erb');
  }
}
