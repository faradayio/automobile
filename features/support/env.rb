require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/formatter/unicode'

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'), :earth => :automobile
