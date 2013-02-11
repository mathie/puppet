class itison::app_server($rails_env = 'production', $static_asset_server = false, $email_app_server = false) {
  class {
    'itison::code':
      rails_env => $rails_env;
  }

  rails::unicorn {
    'itison':
      rails_env    => $rails_env,
      ruby_version => '1.8';
  }

  Class['itison::code'] -> Rails::Unicorn['itison']

  @@nginx::upstream::server {
    "itison-appserver-${::hostname}-${rails_env}":
      upstream => "itison_${rails_env}",
      target   => "${::fqdn}:80",
      options  => 'fail_timeout=60 max_fails=2';
  }

  @@nginx::upstream::server {
    "itison-appserver-${::hostname}-${rails_env}_ssl":
      upstream => "itison_${rails_env}_ssl",
      target   => "${::fqdn}:443",
      options  => 'fail_timeout=60 max_fails=2';
  }

  if $static_asset_server {
    @@nginx::upstream::server {
      "itison_asset_${::hostname}_${rails_env}":
        upstream => "itison_asset_${rails_env}",
        target   => "${::fqdn}:80",
        options  => 'max_fails=2 fail_timeout=60';

      "itison_asset_${::hostname}_${rails_env}_ssl":
        upstream => "itison_asset_${rails_env}_ssl",
        target   => "${::fqdn}:443",
        options  => 'max_fails=2 fail_timeout=60';
    }
  }

  if $email_app_server {
    @@nginx::upstream::server {
      "itison_email_${::hostname}_${rails_env}":
        upstream => "itison_email_${rails_env}",
        target   => "${::fqdn}:80",
        options  => 'max_fails=2 fail_timeout=60';

      "itison_email_${::hostname}_${rails_env}_ssl":
        upstream => "itison_email_${rails_env}_ssl",
        target   => "${::fqdn}:443",
        options  => 'max_fails=2 fail_timeout=60';
    }
  }
}
