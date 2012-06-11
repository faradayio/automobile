require 'bundler'
Bundler.setup

require 'cucumber'

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'),
  # :adapter => 'mysql2',
  # :database => 'test_flight',
  # :username => 'root',
  # :password => 'password',
  :earth => [:automobile, :locality],
  :cucumber => true,
  :logger => 'log/test_log.txt'
