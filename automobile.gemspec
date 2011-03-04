# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)
require "automobile/version"

Gem::Specification.new do |s|
  s.name = "automobile"
  s.version = BrighterPlanet::Automobile::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['Derek Kastner', 'Seamus Abshere', 'Andy Rossmeissl', 'Ian Hough', 'Matt Kling']
  s.email = ['derek.kastner@brighterplanet.com']
  s.homepage = 'https://github.com/brighterplanet/automobile'
  s.summary = %q{A carbon model}
  s.description = %q{A software model in Ruby for the greenhouse gas emissions of an automobile}
  
  s.rubyforge_project = "automobile"
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_development_dependency(%q<activerecord>, ["~> 3"])
  s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<cucumber>, [">= 0"])
  s.add_development_dependency(%q<jeweler>, ["~> 1.4.0"])
  s.add_development_dependency(%q<rdoc>, [">= 0"])
  s.add_development_dependency(%q<rspec>, ["~> 2"])
  s.add_development_dependency(%q<sniff>, ["~> 0.6"])
  s.add_runtime_dependency(%q<emitter>, ["~> 0.4"])
  s.add_runtime_dependency(%q<earth>, ["~> 0.4"])
end
