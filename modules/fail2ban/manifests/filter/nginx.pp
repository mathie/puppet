class fail2ban::filter::nginx {
  fail2ban::filter {
    'nginx':
      ensure  => present,
      content => template('fail2ban/filter/nginx.conf.erb');
  }

  fail2ban::filter {
    'nginx_scripts':
      ensure  => present,
      content => template('fail2ban/filter/nginx_scripts.conf.erb');
  }

  fail2ban::filter {
    'rails_attacks':
      ensure  => present,
      content => template('fail2ban/filter/rails_attacks.conf.erb');
  }
}
