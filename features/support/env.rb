require 'bundler'
Bundler.setup

require 'cucumber'
require 'cucumber/formatter/unicode'

require 'data_miner'
DataMiner.logger = Logger.new($stderr)

require 'sniff'
Sniff.init File.join(File.dirname(__FILE__), '..', '..'), :earth => [:automobile, :fuel], :cucumber => true, :logger => 'log/test_log.txt'
