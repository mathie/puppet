# Common setup for every VM
def bootstrap(config, hostname, ip_address, options = {})
  config.vm.network :hostonly, ip_address

  if forward_ports = options[:forward_ports]
    forward_ports.each do |guest_port, host_port|
      config.vm.forward_port guest_port, host_port
    end
  end

  config.vm.provision :shell do |shell|
    shell.path = 'bootstrap/vagrant-puppet.sh'
    shell.args = "#{hostname} vagrant.vm #{options[:puppetmaster_ip]}"
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

Vagrant::Config.run do |config|
  # Base box is a recently dist-upgrade'd 64-bit Ubuntu 12.04 LTS.
  config.vm.box = "ubuntu-12.04-server-amd64-4.1.20"
  config.vm.box_url = "http://mathie-vagrant-boxes.s3.amazonaws.com/ubuntu-12.04-server-amd64-4.1.20.box"

  puppetmaster_ip = '172.16.27.11'

  config.vm.define :puppet do |puppet|
    puppet_master_bootstrap(puppet, puppetmaster_ip)
  end

  # All the puppet client nodes in the world ever
  {
    :node        => {},
    :temperature => {}
  }.each_with_index do |(hostname, options), i|
    config.vm.define hostname do |host_config|
      puppet_agent_bootstrap(host_config, hostname, "172.16.27.#{i + 101}", { :puppetmaster_ip => puppetmaster_ip }.merge(options))
    end
  end
end
