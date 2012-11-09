define postfix::alias($destination, $order = 50) {
  concat::fragment {
    "postfix-mail-alias-${name}":
      file    => 'postfix-mail-aliases',
      content => "${name}: ${destination}\n",
      order   => $order;
  }
}
