ENV.each do |name, value|
  if /^LOCAL_(.+)/.match(name)
    gem $1.downcase, :path => value
  end
end

source :rubygems

gemspec :path => '.'
