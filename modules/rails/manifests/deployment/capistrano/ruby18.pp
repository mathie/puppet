class rails::deployment::capistrano::ruby18 {
  include rails::deployment::capistrano::base
  include ruby::ruby18
  include ruby::bundler18
}
