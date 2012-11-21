#!/usr/bin/env rake

module_manifests = FileList['modules/*/manifests/**/*.pp']
local_manifests  = FileList['manifests/**/*.pp']
manifests = module_manifests + local_manifests

def bundle_exec(command, options = {}, &block)
  ruby "-S bundle exec #{command}", { :verbose => false }.merge(options), &block
end

def puppet(command, manifests)
  bundle_exec "puppet #{command} #{manifests}"
end

$error_count = 0
def puppet_lint(manifest, args = "")
  bundle_exec "puppet-lint --log-format '%{path}:%{linenumber} - %{kind}: %{message}.' --no-80chars-check --no-documentation-check #{args} #{manifest}" do |ok, res|
    $error_count += 1 unless ok
  end
end

def puppet_lint_many(manifests, args = "")
  manifests.each do |manifest|
    puppet_lint(manifest, args)
  end
end

task :default => [ :test ]

desc "Run all the available puppet tests."
task :test => ["test:validate", "test:lint"]

namespace :test do
  desc "Validate the puppet manifests with puppet itself."
  task :validate => manifests do
    puppet "parser validate", manifests
  end

  desc "Run all the manifests through puppet-lint."
  task :lint => ["lint:modules", "lint:manifests"] do
    fail "puppet-lint reported #{$error_count} errors." if $error_count > 0
  end

  namespace :lint do

    task :modules => module_manifests do
      puppet_lint_many(module_manifests)
    end

    task :manifests => local_manifests do
      puppet_lint_many(local_manifests, "--no-autoloader_layout-check")
    end
  end
end

namespace :bootstrap do
  def run_instance(node_name, user_data = nil, options = {})
    user_data ||= node_name

    sh "scp build/user-data/#{user_data} hyp-01.ovh.rubaidh.net:/home/mathie/#{user_data}"
    sh "ssh hyp-01.ovh.rubaidh.net -t 'sudo lxc-create -n #{node_name} -t ubuntu-cloud -- --userdata /home/mathie/#{user_data} && sudo ln -snf /var/lib/lxc/#{node_name}/config /etc/lxc/auto/#{node_name}.conf && sudo lxc-start -n #{node_name} -d'"
  end

  def puppetmaster_ip
    ENV['PUPPETMASTER_IP'] || '5.39.117.102'
  end

  task :puppetmaster => 'user_data:puppetmaster' do
    run_instance 'puppet', 'puppetmaster'
  end

  task :node => 'user_data:node' do
    run_instance ENV['NODE_NAME']
  end
end

namespace :user_data do
  task :puppetmaster => ['build/user-data'] do
    sh "bin/write-mime-multipart -o build/user-data/puppetmaster bootstrap/ec2-user-data/puppetmaster.cloud-config.yaml:text/cloud-config bootstrap/ec2-user-data/puppetmaster.sh:text/x-shellscript"
  end

  task :node => ['build/user-data'] do
    raise "Must specify a NODE_NAME" if ENV['NODE_NAME'].nil?

    sh "sed -e 's/@@NODE_NAME@@/#{ENV['NODE_NAME']}/g' -e 's/@@PUPPETMASTER_IP@@/#{puppetmaster_ip}/g' < bootstrap/ec2-user-data/node.cloud-config.yaml.in > build/user-data/#{ENV['NODE_NAME']}"
  end

  directory 'build/user-data'
end

namespace :modules do
  task :update do
    remote_modules = {
      'vcsrepo' => 'git://github.com/puppetlabs/puppetlabs-vcsrepo'
    }

    remote_modules.each do |dir, remote|
      remote_name = "#{dir}-subtree-remote"
      sh "git remote add #{remote_name} #{remote} || true"
      sh "git fetch #{remote_name}"
      dir = "modules/#{dir}"
      if File.directory?(dir)
        sh "git merge --squash -s subtree #{remote_name}/master --no-commit"
        sh "git commit -m 'Subtree update of #{dir} from #{remote}.' || true"
      else
        sh "git read-tree --prefix=#{dir}/ #{remote_name}/master"
        sh "git commit -m 'Initial import of #{dir} from #{remote}.'"
        sh "git checkout #{dir}"
      end
    end
  end
end
