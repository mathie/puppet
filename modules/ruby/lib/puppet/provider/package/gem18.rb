Puppet::Type.type(:package).provide :gem18, :parent => :gem, :source => :gem do
  has_feature :versionable

  commands :gemcmd => 'gem1.8'
end
