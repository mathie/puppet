class ProvisionerRegistry
  def initialize
    @provisioner_classes = []
  end

  def config_file=(new_config_file)
    @config_file = new_config_file
  end

  def register_provisioner(provisioner_class)
    @provisioner_classes << provisioner_class
  end

  def generate_rake_tasks
    raise "Can't generate rake tasks without first setting the config file" unless @config_file

    @provisioner_classes.each do |provisioner_class|
      provisioner = provisioner_class.new(@config_file)
      provisioner.generate_rake_tasks
    end
  end
end

Dir[File.expand_path('../provisioners/*.rb', __FILE__)].each do |f|
  require f
end
