class phantomjs {
  include xvfb

  $url = 'http://phantomjs.googlecode.com/files/phantomjs-1.8.0-linux-x86_64.tar.bz2'
  $tarball = '/opt/phantomjs-1.8.0-linux-x86_64.tar.bz2'

  package {
    'phantomjs':
      ensure => absent;
  }

  exec {
    'download-phantomjs-binary':
      command => "/usr/bin/curl -L -o ${tarball} ${url}",
      creates => $tarball;

    'unpack-phantomjs-binary':
      command  => "/bin/tar jxf ${tarball}",
      cwd      => '/opt',
      creates  => '/opt/phantomjs-1.8.0-linux-x86_64',
      requires => Exec['download-phantomjs-binary'];
  }

  file {
    '/usr/local/bin/phantomjs':
      ensure => link,
      target => '/opt/phantomjs-1.8.0-linux-x86_64/bin/phantomjs';
  }
}
