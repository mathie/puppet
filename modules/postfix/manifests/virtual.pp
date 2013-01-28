define postfix::virtual($destination, $order = 50) {
  concat::fragment {
    "postfix-virtual-${name}":
      file    => 'postfix-virtual',
      content => "${name} ${destination}\n",
      order   => $order;
  }
}

