# A list of nodes to bring up, with options for each.
$nodes = {
  :node => {}
}

# Customisation for the puppetmaster
$puppetmaster_options = {
  :forward_ports =>  { 8084 => 8084, 8085 => 8085, 8086 => 8086, 8087 => 8087 }
}

# Variables you might want to change
$base_box_name   = "ubuntu-12.04.2-server-amd64"
$ip_network      = "172.16.27.%d"
$puppetmaster_ip = 10
$node_base_ip    = 100

# Common setup for every VM
def bootstrap(config, hostname, ip_address, options = {})
  config.vm.network :private_network, :ip => ip_address

  if forward_ports = options[:forward_ports]
    forward_ports.each do |guest_port, host_port|
      config.vm.network :forwarded_port, :guest => guest_port, :host => host_port
    end
  end

  graphs_folder = "graphs/#{hostname}"
  FileUtils.mkdir_p(graphs_folder) unless File.directory?(graphs_folder)
  config.vm.synced_folder graphs_folder, '/var/lib/puppet/state/graphs'

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

Vagrant.configure('2') do |config|
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
