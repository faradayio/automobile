require 'bundler/setup'

require 'sniff'
Sniff.init File.expand_path('../../..', __FILE__),
  :cucumber => true,
  :logger => false # change this to $stderr to see database activity
