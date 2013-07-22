require 'provisioners/base'

class VagrantProvisioner < Provisioner
  protected
  def run_instance(_)
    benchmark "Bootstrapping #{config('node_name')}" do
      system "vagrant up #{config('node_name')}"
    end
  end
end

Provisioner.registry.register_provisioner(VagrantProvisioner)
