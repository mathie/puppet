class bootstrap::common {
  include stages

  class {
    'apt':
      stage => first;
  }
}
