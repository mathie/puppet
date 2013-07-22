#!/usr/bin/env rake

$: << File.expand_path('../lib', __FILE__)

require 'provisioners'
Provisioner.registry.config_file = 'config/provisioning.yml'
Provisioner.registry.generate_rake_tasks

require 'puppet_test'
linter = PuppetTest.new(
  FileList['modules/*/manifests/**/*.pp'],
  FileList['manifests/**/*.pp'],
  [ '80chars', 'documentation' ]
)

task :default => [ :test ]

desc "Run all the available puppet tests."
task :test => ["test:validate", "test:lint"]

namespace :test do
  desc "Validate the puppet manifests with puppet itself."
  task :validate do
    linter.validate
  end

  desc "Run all the manifests through puppet-lint."
  task :lint => ["lint:modules", "lint:manifests"] do
    fail "puppet-lint reported #{linter.error_count} errors." if linter.error_count > 0
  end

  namespace :lint do

    task :modules do
      linter.lint_modules
    end

    task :manifests do
      linter.lint_manifests
    end
  end
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
