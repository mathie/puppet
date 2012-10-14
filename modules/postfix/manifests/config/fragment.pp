define postfix::config::fragment($key, $value, $order = 50) {
  concat::fragment {
    "postfix-config-fragment-${name}":
      file    => 'postfix-main-cf',
      content => "${key} = ${value}\n",
      order   => $order;
  }
}
