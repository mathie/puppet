#!/usr/bin/env rake

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
