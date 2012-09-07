define collectd::plugin($ensure = present, $plugin = $name, $config = undef) {
  file {
    "/etc/collectd/conf.d/${plugin}.load":
      ensure  => $ensure,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => "LoadPlugin ${plugin}\n",
      notify  => Class['collectd::service'];
  }

  if $config {
    file {
      "/etc/collectd/conf.d/${plugin}.conf":
        ensure  => $ensure,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => "<Plugin ${plugin}>\n${config}\n</Plugin>\n",
        notify  => Class['collectd::service'];
    }
  }
}
