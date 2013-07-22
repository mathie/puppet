class chat::app_server {
  include chat::code

  rails::thin {
    'chat':
      app_servers => 4;
  }

  Class['chat::code'] -> Rails::Thin['chat']

  @@nginx::upstream::server {
    "chat-appserver-${::hostname}":
      upstream => 'chat',
      target   => "${::ipaddress_preferred}:80",
      options  => 'fail_timeout=2';
  }
}
