Puppet::Type.type(:package).provide :gem19, :parent => :gem, :source => :gem do
  has_feature :versionable

  commands :gemcmd => 'gem1.9.1'
end
