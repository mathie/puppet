class ci::slave {
  include jenkins::slave
  include ci::config
  include ci::dependencies

  Class['jenkins::slave'] -> Class['ci::config']
}
