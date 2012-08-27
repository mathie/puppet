$bootstrapping = true

import '../classes/puppetmaster'

node 'puppet' {
  include puppetmaster
}
