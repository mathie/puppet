class phantomjs {
  include xvfb

  $version      = '1.8.1'
  $basename     = "phantomjs-${version}-linux-x86_64"
  $tarball      = "${basename}.tar.bz2"
  $tarball_path = "/opt/${tarball}"
  $url          = "http://phantomjs.googlecode.com/files/${tarball}"
  $destdir      = "/opt/${basename}"

  package {
    'phantomjs':
      ensure => absent;
  }

  exec {
    'download-phantomjs-binary':
      command => "/usr/bin/curl -L -o ${tarball_path} ${url}",
      creates => $tarball_path;

    'unpack-phantomjs-binary':
      command => "/bin/tar jxf ${tarball_path}",
      cwd     => '/opt',
      creates => $destdir,
      require => Exec['download-phantomjs-binary'];
  }

  file {
    '/usr/local/bin/phantomjs':
      ensure  => link,
      target  => "${destdir}/bin/phantomjs",
      require => Exec['unpack-phantomjs-binary'];
  }
}
