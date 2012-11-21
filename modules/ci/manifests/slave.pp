class ci::slave($master) {
  class {
    'jenkins::slave':
      master => $master;
  }

  include ci::config
  include ci::dependencies

  Class['jenkins::slave'] -> Class['ci::config']
}
