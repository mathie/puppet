define apt::key($keyid) {
  exec {
    "apt-key-${keyid}":
      command => "/usr/bin/apt-key adv --keyserver hkp://subkeys.pgp.net --recv-keys ${keyid}",
      unless  => "/usr/bin/apt-key list |grep ${keyid} >/dev/null 2>&1";
  }
}

