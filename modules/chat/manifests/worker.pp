class chat::worker {
  include chat::code

  file {
    '/etc/init/chat-pusher.conf':
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('chat/chat-pusher-init.erb');
  }

  service {
    'chat-pusher':
      ensure  => running,
      enable  => true;
  }

  Class['chat::code'] -> Service['chat-pusher']
  File['/etc/init/chat-pusher.conf'] ~> Service['chat-pusher']
}
