$bootstrapping = true

import '../classes/bootstrap_common'
import '../classes/puppetmaster'

node 'puppet' {
  include bootstrap_common
  include puppetmaster
}
