class pygments {
  include python::pip

  package {
    'Pygments':
      ensure   => installed,
      provider => 'pip';
  }
}
