define postfix::virtual_domain($order = 40) {
  postfix::virtual {
    $name:
      destination => $name,
      order       => $order;
  }
}

