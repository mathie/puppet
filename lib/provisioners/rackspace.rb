require 'provisioners/base'
require 'fog'

class RackspaceProvisioner < Provisioner
  def initialize(config_file)
    super

    @default_config['rackspace_auth_url'] = 'lon.auth.api.rackspacecloud.com'
  end

  protected
  def run_instance(puppet_manifest)
    server = launch_server
    wait_for_nova_agent
    upload_bootstrap_script(server)
    run_bootstrap_script(puppet_manifest, server)
  end

  def launch_server
    server = nil

    benchmark "Launching #{fqdn}. This will block until it completes which could be a while. Patience!" do
      server = fog_connection.servers.create(
        :flavor_id   => default_flavor.id,
        :image_id    => default_image.id,
        :name        => fqdn
      )
      server.wait_for { ready? }
      puts "ssh #{server.username}@#{server.public_ip_address} with password '#{server.password}'."
    end

    server
  end

  def wait_for_nova_agent
    puts "Waiting another 30 seconds so nova-agent has time to set the root password."
    sleep 30
    puts "Done sleeping."
  end

  def upload_bootstrap_script(server)
    benchmark "Copying bootstrap script across." do
      scp = Fog::SCP.new server.public_ip_address, server.username, :password => server.password
      scp.upload bootstrap_script, "/usr/local/bin/bootstrap.sh"
    end
  end

  def run_bootstrap_script(puppet_manifest, server)
    benchmark "SSHing in to run the bootstrap script." do
      ssh = Fog::SSH.new server.public_ip_address, server.username, :password => server.password
      ssh.run "chmod a+x /usr/local/bin/bootstrap.sh && /usr/local/bin/bootstrap.sh #{config('node_name')} #{config('domain_name')} #{puppet_manifest} #{config('puppetmaster_ip')}" do |out, err|
        STDOUT.puts "[STDOUT] #{out}" unless out == ''
        STDERR.puts "[STDERR] #{err}" unless err == ''
      end
    end
  end

  def default_image
    @default_image ||= fog_connection.images.find { |image| image.name =~ /#{default_image_name}/ }
  end

  def default_flavor
    @default_flavor ||= flavor(default_ram)
  end

  def flavor(ram)
    fog_connection.flavors.find { |flavor| flavor.ram == ram }
  end

  def fog_connection
    @fog_connection ||= Fog::Compute.new(
      :provider           => 'Rackspace',
      :rackspace_username => rackspace_username,
      :rackspace_api_key  => rackspace_api_key,
      :rackspace_auth_url => rackspace_auth_url
    )
  end
end

Provisioner.registry.register_provisioner(RackspaceProvisioner)
