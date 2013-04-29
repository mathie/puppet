# Not quite true, but close enough for now, I think.
Facter.add(:vagrant) do
  setcode do
    if File.directory?('/vagrant')
      'true'
    else
      'false'
    end
  end
end

