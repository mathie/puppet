define apt::repository(
  $url,
  $distribution = $::lsbdistcodename,
  $components   = [ 'main' ],
  $keyid        = undef
) {
  include apt

  $source_file = "/etc/apt/sources.list.d/${title}.list"

  file {
    $source_file:
      ensure  => present,
      owner   => root,
      group   => root,
      mode    => '0644',
      content => template('apt/sources.list.erb');
  }

  if $keyid {
    apt::key {
      $title:
        keyid => $keyid;
    }

    Apt::Key[$title] -> File[$source_file]
  }

  anchor { "apt::repository::${title}::begin": } ->
    File[$source_file] ~>
    Exec['apt-get-update'] ->
    anchor { "apt::repository::${title}::end": }
}
