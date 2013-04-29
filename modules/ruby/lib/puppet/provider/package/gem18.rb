Puppet::Type.type(:package).provide :gem18, :parent => :gem, :source => :gem do
  has_feature :versionable

  commands :gemcmd => 'gem1.8'

  def install(useversion = true)
    command = [command(:gemcmd), "install"]
    command << "-v" << resource[:ensure] if (! resource[:ensure].is_a? Symbol) and useversion
    # Always include dependencies
    command << "--include-dependencies"

    if source = resource[:source]
      begin
        uri = URI.parse(source)
      rescue => detail
        fail "Invalid source '#{uri}': #{detail}"
      end

      case uri.scheme
      when nil
        # no URI scheme => interpret the source as a local file
        command << source
      when /file/i
        command << uri.path
      when 'puppet'
        # we don't support puppet:// URLs (yet)
        raise Puppet::Error.new("puppet:// URLs are not supported as gem sources")
      else
        # interpret it as a gem repository
        command << "--source" << "#{source}" << resource_name
      end
    else
      command << "--no-rdoc" << "--no-ri" << resource_name
    end

    output = execute(command)
    # Apparently some stupid gem versions don't exit non-0 on failure
    self.fail "Could not install: #{output.chomp}" if output.include?("ERROR")
  end

  def query
    self.class.gemlist(:justme => resource_name, :local => true)
  end

  private
  def resource_name
    resource[:name].gsub(/18$/, '')
  end
end
