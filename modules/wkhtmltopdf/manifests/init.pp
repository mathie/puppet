class wkhtmltopdf {
  include xvfb

  package {
    [ 'wkhtmltopdf', 'ttf-mscorefonts-installer' ]:
      ensure => present;
  }

  file {
    '/usr/bin/wkhtmltopdf-xvfb-shim':
      ensure => present,
      source => 'puppet:///modules/wkhtmltopdf/wkhtmltopdf-xvfb-shim',
      owner  => root,
      group  => root,
      mode   => '0755';
  }
}
