Facter.add(:datacenter) do
  setcode do
    Facter.fqdn.split('.')[1]
  end
end
