define mysql::server::nrpe_check_status_percent(
  $description,
  $current,
  $total,
  $warning,
  $critical
) {
  mysql::server::nrpe_check_status {
    "${name}-percent":
      description => $description,
      arguments   => "-x ${current} -o / -y ${total} -T pct",
      warning     => $warning,
      critical    => $critical;
  }
}
