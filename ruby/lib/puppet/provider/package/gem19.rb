Puppet::Type.type(:package).provide :gem19, :parent => :gem, :source => :gem do
  commands :gemcmd => 'gem1.9.1'
end
