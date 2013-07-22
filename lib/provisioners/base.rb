class Provisioner
  def self.registry
    @registry ||= ProvisionerRegistry.new
  end

  def initialize(config_file)
    @global_config      = YAML.load_file(config_file)
    @provisioner_config = @global_config.delete(rake_namespace) || {}
    @default_config     = {
      'puppetmaster_hostname' => 'puppet'
    }
  end

  def generate_rake_tasks
    Rake.application.in_namespace rake_namespace do
      Rake.application.last_description = "Bootstrap a puppetmaster"
      Rake::Task.define_task :puppetmaster => bootstrap_script do
        bootstrap_puppetmaster
      end

      Rake.application.last_description = "Bootstrap a node - needs NODE_NAME to be set in the environment"
      Rake::Task.define_task :node => bootstrap_script do
        bootstrap_agent
      end

      Rake::Task.define_task bootstrap_script => bootstrap_script_sources do
        generate_bootstrap_script
      end
    end
  end

  protected
  def config(key)
    key = key.to_s

    value = ENV["#{key.upcase}"] ||
      @provisioner_config[key]   ||
      @global_config[key]        ||
      @default_config[key]

    raise "Can't find config value for #{key}. Maybe #{key.upcase} is needed in the environment?" unless value

    value
  end

  def bootstrap_puppetmaster
    @provisioner_config['node_name'] ||= config('puppetmaster_hostname')
    run_instance 'puppetmaster'
  end

  def bootstrap_agent
    run_instance 'agent'
  end

  def generate_bootstrap_script
    system "cat #{bootstrap_script_sources.join(' ')} | sed -e 's\#@@GIT_REPO@@\##{config('git_repo')}\#' -e 's\#@@SSH_PRIVATE_KEY@@\##{ssh_key}\#' > #{bootstrap_script}"
  end

  def bootstrap_script_sources
    [
      'bootstrap/common-puppet.sh.in',
      "bootstrap/#{rake_namespace}-puppet.sh.in"
    ]
  end

  def benchmark(message)
    puts message
    start_time = Time.now
    yield
    end_time = Time.now - start_time
    puts "    -> #{end_time}s"
  end

  def rake_namespace
    self.class.name.gsub(/Provisioner$/, '').downcase
  end

  def bootstrap_script
    "build/#{rake_namespace}-puppet.sh"
  end

  def ssh_key
    File.read('modules/users/files/keys/root.keys').chomp.gsub(/\n/, "\\\n")
  end
end
