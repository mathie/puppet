Puppet::Type.type(:package).provide :gem18, :parent => :gem, :source => :gem do
  commands :gemcmd => 'gem1.8'
end
