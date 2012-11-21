class bootstrap_common {
  include stages
  class {
    'eatmydata':
      stage => first;
  }
}
