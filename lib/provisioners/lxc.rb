require 'provisioners/base'

class LxcProvisioner < Provisioner
  protected
  def run_instance(puppet_manifest)
    generated_file = generate_bootstrap_data(puppet_manifest)
    scp generated_file, lxc_host
    execute_on_lxc_host commands(generated_file).join(' && ')
  end

  def lxc_host
    config('lxc_host')
  end

  def commands(bootstrap_data_file)
    [
      lxc_create(bootstrap_data_file),
      autostart,
      start,
      cleanup(bootstrap_data_file)
    ]
  end

  def lxc_create(bootstrap_data_file)
    hostname = config('node_name')

    sudo "lxc-create -n #{hostname} -t ubuntu-cloud -- --userdata /tmp/#{File.basename(bootstrap_data_file)}"
  end

  def autostart
    hostname = config('node_name')

    sudo "ln -snf /var/lib/lxc/#{hostname}/config /etc/lxc/auto/#{hostname}.conf"
  end

  def start
    hostname = config('node_name')

    sudo "lxc-start -n #{hostname} -d"
  end

  def cleanup(bootstrap_data_file)
    sudo "rm -f /tmp/#{bootstrap_data_file}"
  end

  def sudo(command)
    "sudo #{command}"
  end

  def execute_on_lxc_host(command)
    system "ssh #{lxc_host} -t '#{command}'"
  end

  def scp(file, destination_host, destination_directory = '/tmp')
    system "scp #{file} #{destination_host}:#{destination_directory}/#{File.basename(file)}"
  end

  # Bootstrap data is built on every run with this provisioner, not just when things change.
  def bootstrap_script_sources
    []
  end

  def generate_bootstrap_script
  end

  def generate_bootstrap_data(puppet_manifest)
    unless [ 'puppetmaster', 'agent' ].include?(puppet_manifest)
      raise "Don't know how to create bootstrap data for puppet node type, #{puppet_manifest}"
    end

    output_filename = "build/#{puppet_manifest}"
    input_files = [
      [ "#{puppet_manifest}.cloud-config.yaml", 'text/cloud-config'  ],
      [ "#{puppet_manifest}.sh",                'text/x-shellscript' ]
    ]

    intermediate_files = preprocess_all(input_files)

    if intermediate_files.size > 1
      write_multipart(output_filename, intermediate_files)
    else
      write_output(output_filename, intermediate_files[0][0])
    end
  end

  def preprocess_all(input_files)
    input_files.select do |base_name, _|
      File.exist?("bootstrap/user-data/#{base_name}.in")
    end.map do |base_name, mime_type|
      [ preprocess(base_name), mime_type ]
    end
  end

  def preprocess(base_name)
    input_file  = "bootstrap/user-data/#{base_name}.in"
    output_file = "build/#{base_name}"

    sed preprocess_expressions, input_file, output_file

    output_file
  end

  def sed(preprocess_expressions, input_file, output_file)
    command_line = preprocess_expressions.map { |expression| "-e '#{expression}'" }.join(' ')
    system "sed #{command_line} < #{input_file} > #{output_file}"
  end

  def preprocess_expressions
    variables_to_replace.map do |name|
      name  = name.to_s
      value = respond_to?(name) ? send(name) : config(name)

      "s\#@@#{name.upcase}@@\##{value}\#g"
    end
  end

  def variables_to_replace
    [
      :puppetmaster_ip,
      :fqdn,
      :node_name,
      :domain_name,
      :ssh_key,
      :git_repo
    ]
  end

  def write_multipart(output_filename, intermediate_files)
    command_line = intermediate_files.map do |filename, mime_type|
      [filename, mime_type].join(':')
    end.join(' ')

    system "bin/write-mime-multipart -o #{output_filename} #{command_line}"

    output_filename
  end

  def write_output(output_filename, intermediate_filename)
    system "cat > #{output_filename} < #{intermediate_filename}"

    output_filename
  end

  def fqdn
    [config('node_name'), config('domain_name')].join('.')
  end
end

Provisioner.registry.register_provisioner(LxcProvisioner)
