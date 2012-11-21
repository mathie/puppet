define jenkins::plugin($version = 0) {
  include jenkins

  $package = "${name}.hpi"
  $plugin_url = $version ? {
    0       => "http://updates.jenkins-ci.org/latest/${package}",
    default => "http://updates.jenkins-ci.org/download/plugins/${name}/${version}/${package}",
  }
  $plugin_dir  = '/var/lib/jenkins/plugins'
  $destination = "${plugin_dir}/${package}"

  exec {
    "jenkins-install-plugin-${name}":
      command => "/usr/bin/curl -L -o ${destination} ${plugin_url}",
      creates => $destination,
      cwd     => $plugin_dir,
      user    => jenkins,
      notify  => Class['jenkins::service'];
  }

  Class['jenkins::install'] -> Exec["jenkins-install-plugin-${name}"]
}
