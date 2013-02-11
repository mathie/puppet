class itison::hosts {
  if $::virtual != 'virtualbox' {
    host {
      'einstein.itison.com':
        ensure       => present,
        ip           => '10.177.130.177',
        host_aliases => [ 'einstein' ];

      'pauli.itison.com':
        ensure       => present,
        ip           => '10.177.130.251',
        host_aliases => [ 'pauli' ];

      'maxwell.itison.com':
        ensure       => present,
        ip           => '10.177.130.245',
        host_aliases => [ 'maxwell' ];

      'yvonne.itison.com':
        ensure       => present,
        ip           => '10.177.130.196',
        host_aliases => [ 'yvonne' ];

      'wooster.itison.com':
        ensure       => present,
        ip           => '10.177.128.106',
        host_aliases => [ 'wooster' ];

      'kitson.itison.com':
        ensure       => present,
        ip           => '10.177.130.255',
        host_aliases => [ 'kitson' ];

      'hicks.itison.com':
        ensure       => present,
        ip           => '10.177.131.59',
        host_aliases => [ 'hicks' ];

    }
  }
}
