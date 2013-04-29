define concat::file(
  $path,
  $ensure = present,
  $owner  = undef,
  $group  = undef,
  $mode   = undef,
  $head   = undef,
  $tail   = undef
) {
  include concat

  $fragment_dir = "${concat::fragment_root}/${name}"

  file {
    $fragment_dir:
      ensure  => directory,
      recurse => true,
      purge   => true;

    "${fragment_dir}/00_empty_file":
      ensure  => present,
      content => '';
  }

  $generate_command = '/bin/cat `/bin/ls * | /usr/bin/sort -n -t _ -k1`'

  if $ensure == present {
    exec {
      "concat-${name}":
        cwd     => $fragment_dir,
        command => "${generate_command} > ${path}",
        unless  => "${generate_command} | cmp ${path}",
        require => File["${fragment_dir}/00_empty_file"];
    }

    file {
      $path:
        ensure  => $ensure,
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        require => Exec["concat-${name}"];
    }
  } else {
    file {
      $path:
        ensure => $ensure;
    }
  }

  if($head) {
    concat::fragment {
      "${name}-head":
        file    => $name,
        order   => 0,
        content => $head;
    }
  }

  if($tail) {
    concat::fragment {
      "${name}-tail":
        file    => $name,
        order   => 99,
        content => $tail;
    }
  }
}
