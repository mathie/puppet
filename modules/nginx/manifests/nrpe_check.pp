define nginx::nrpe_check(
  $vhost         = $name,
  $authenticated = false,
  $username      = $nagios::agent::htpasswd_user,
  $password      = $nagios::agent::htpasswd_password,
  $port          = undef,
  $ssl           = false
) {

  $port_arg = $port ? {
    undef   => '',
    default => " -p ${port}",
  }
  $auth_arg = $authenticated ? {
    true  => " -a ${username}:${password}",
    false => '',
  }
  $ssl_arg = $ssl ? {
    true  => ' --ssl',
    false => '',
  }
  $shared_args = "-H ${vhost} -I 127.0.0.1${auth_arg}${port_arg}${ssl_arg}"

  if $ssl {
    if $port {
      $check_name = "${vhost}-${port}-https"
      $description = "HTTPS vhost ${vhost}:${port}"
    } else {
      $check_name = "${vhost}-https"
      $description = "HTTPS vhost ${vhost}"
    }
  } else {
    if $port {
      $check_name = "${vhost}-${port}-http"
      $description = "HTTP vhost ${vhost}:${port}"
    } else {
      $check_name = "${vhost}-http"
      $description = "HTTP vhost ${vhost}"
    }
  }

  nagios::nrpe_check {
    $check_name:
      service_description => $description,
      check_command       => 'check_http',
      arguments           => $shared_args;
  }

  if $ssl {
    nagios::nrpe_check {
      "${check_name}-cert":
        service_description => "${description} SSL certificate",
        check_command       => 'check_http',
        arguments           => "${shared_args} -C 14";
    }
  }
}
