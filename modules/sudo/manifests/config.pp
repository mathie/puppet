class sudo::config {
  concat::file {
    'sudoers':
      path  => '/etc/sudoers',
      owner => root,
      group => root,
      mode  => '0440',
      head  => template('sudo/sudoers.erb');
  }

  sudo::user {
    'root-is-all-powerful':
      user => root;
  }

  if str2bool($::vagrant) == true {
    sudo::user {
      'vagrant-is-also-all-powerful':
        user        => vagrant,
        no_password => true;
    }
  }
}
