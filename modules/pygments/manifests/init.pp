class pygments {
  include python::pip

  package {
    'pygments':
      ensure   => installed,
      provider => 'pip';
  }
}
