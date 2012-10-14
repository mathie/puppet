# A list of nodes to bring up, with options for each.
$nodes = {
  :node => {}
}

# Customisation for the puppetmaster
$puppetmaster_options = {
  :memory        => 512,
  :forward_ports => { 8084 => 8084 }
}

# Variables you might want to change
$base_box_name   = "ubuntu-12.04-server-amd64-4.2.0-1"
$ip_network      = "172.16.27.%d"
$puppetmaster_ip = 10
$node_base_ip    = 100

# Common setup for every VM
def bootstrap(config, hostname, ip_address, options = {})
  if memory = options.delete(:memory)
    config.vm.customize ["modifyvm", :id, "--memory", memory]
  end

  config.vm.network :hostonly, ip_address

  if forward_ports = options[:forward_ports]
    forward_ports.each do |guest_port, host_port|
      config.vm.forward_port guest_port, host_port
    end
  end

  config.vm.provision :shell do |shell|
    shell.path = 'bootstrap/vagrant-puppet.sh'
    shell.args = "#{hostname} vagrant.vm unused #{ip_address($puppetmaster_ip)}"
  end
end

def puppet_bootstrap(config, hostname, ip_address, manifest, options = {})
  bootstrap(config, hostname, ip_address, options)
  config.vm.provision :puppet do |puppet|
    puppet.manifest_file  = "bootstrap/#{manifest}.pp"
    puppet.manifests_path = 'manifests'
    puppet.module_path    = 'modules'
    if options[:debug]
      puppet.options = ['--verbose', '--debug']
    end
  end
end

def puppet_master_bootstrap(config, ip_address, options = {})
  puppet_bootstrap(config, 'puppet', ip_address, 'puppetmaster', options)
end

def puppet_agent_bootstrap(config, hostname, ip_address, options = {})
  puppet_bootstrap(config, hostname, ip_address, 'agent', options)
end

def ip_address(offset, base = 0)
  $ip_network % (offset + base)
end

Vagrant::Config.run do |config|
  # Base box is a recently dist-upgrade'd 64-bit Ubuntu 12.04 LTS.
  config.vm.box = $base_box_name
  config.vm.box_url = "http://mathie-vagrant-boxes.s3.amazonaws.com/#{$base_box_name}.box"

  config.vm.define :puppet do |puppet|
    puppet_master_bootstrap(puppet, ip_address($puppetmaster_ip), $puppetmaster_options)
  end

  $nodes.each_with_index do |(hostname, options), i|
    config.vm.define hostname do |host_config|
      puppet_agent_bootstrap(host_config, hostname, ip_address(i, $node_base_ip), options)
    end
  end
end
