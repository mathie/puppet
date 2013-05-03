class gunicorn::repo($stage = first) {
  apt::repository {
    'gunicorn':
      url   => 'http://ppa.launchpad.net/gunicorn/ppa/ubuntu',
      keyid => '5370FF2A';
  }
}
