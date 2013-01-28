define postfix::config::fragment($value, $key = $name, $order = 50) {
  concat::fragment {
    "postfix-config-fragment-${name}":
      file    => 'postfix-main-cf',
      content => "${key} = ${value}\n",
      order   => $order;
  }
}
