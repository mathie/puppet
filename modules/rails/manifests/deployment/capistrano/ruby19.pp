class rails::deployment::capistrano::ruby19 {
  include rails::deployment::capistrano::base
  include ruby::ruby19
  include ruby::bundler19
}
