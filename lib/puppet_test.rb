class PuppetTest
  include Rake::FileUtilsExt
  private(*FileUtils.instance_methods(false))
  private(*Rake::FileUtilsExt.instance_methods(false))

  attr_reader :error_count

  def initialize(module_manifests, local_manifests, always_ignored_checks = [])
    @module_manifests      = module_manifests
    @local_manifests       = local_manifests
    @always_ignored_checks = always_ignored_checks
    @error_count           = 0
  end

  def lint_modules
    lint(@module_manifests)
  end

  def lint_manifests
    lint(@local_manifests, [ 'autoloader_layout' ])
  end

  def validate
    puppet "parser validate", [ 'parser=future', 'storeconfigs' ], all_manifests
  end

  protected
  def lint(manifests, ignored_checks = [])
    manifests.each do |manifest|
      puppet_lint(manifest, ignored_checks)
    end
  end

  def all_manifests
    @module_manifests + @local_manifests
  end

  def bundle_exec(command, options = {}, &block)
    ruby "-S bundle exec #{command}", { :verbose => false }.merge(options), &block
  end

  def puppet(command, arguments, manifests)
    arg_string = arguments.map { |arg| "--#{arg}" }.join(' ')
    command_line = [
      'puppet',
      command,
      arg_string,
      manifests
    ].compact.join(' ')
    bundle_exec command_line
  end

  def puppet_lint(manifest, ignored_checks)
    args = generate_args_from_ignored_checks(ignored_checks)

    bundle_exec "puppet-lint --log-format '%{path}:%{linenumber} - %{kind}: %{message}.' #{args} #{manifest}" do |ok, res|
      @error_count += 1 unless ok
    end
  end

  def generate_args_from_ignored_checks(ignored_checks)
    (@always_ignored_checks | ignored_checks).map do |check|
      "--no-#{check}-check"
    end.join(' ')
  end
end
