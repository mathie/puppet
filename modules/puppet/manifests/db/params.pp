class puppet::db::params {
  # Pin to 0.9.1 for now, as 0.9.2 seems to be broken. FIXME Remember to
  # update this when it becomes unbroken again.
  $puppetdb_version = '0.9.1-1puppetlabs1'
}
