Facter.add(:vpn_agent_interface) do
  setcode do
    Facter.interfaces.split(',').select { |interface| interface =~ /^tun[0-9]+/ }.max
  end
end

Facter.add(:ipaddress_vpn) do
  setcode do
    Facter.value("ipaddress_#{Facter.value('vpn_agent_interface')}")
  end
end

Facter.add(:ipaddress_internal) do
  setcode do
    if Facter.value('vagrant') == 'true'
      Facter.value('ipaddress_eth1')
    else
      case Facter.value('virtual')
      when 'xenu' # xenu is Rackspace Cloud
        Facter.value('ipaddress_eth1')
      when 'physical' # An LXC container, I think?
        Facter.value('ipaddress_eth0')
      else
        raise "Don't know the internal IP for #{Facter.value('virtual')}"
      end
    end
  end
end

Facter.add(:ipaddress_preferred) do
  setcode do
    Facter.value('ipaddress_vpn') || Facter.value('ipaddress_internal')
  end
end

Facter.add(:gateway) do
  setcode "ip route | awk '/default/{print $3}'"
end
