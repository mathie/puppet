$bootstrapping = true

import '../classes/bootstrap_common'

node default {
  include bootstrap_common
  include puppet::agent
}
