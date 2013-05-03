import './common'

node default {
  include bootstrap::common
  include puppet::agent
}
