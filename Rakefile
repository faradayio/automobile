require 'rubygems'
unless ENV['NOBUNDLE']
  begin
    require 'bundler'
    Bundler.setup
  rescue LoadError
    puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
  end
end

require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "automobile"
    gem.summary = %Q{A carbon model}
    gem.description = %Q{A software model in Ruby for the greenhouse gas emissions of an automobile}
    gem.email = "andy@rossmeissl.net"
    gem.homepage = "http://github.com/brighterplanet/automobile"
        gem.authors = ["Andy Rossmeissl", "Seamus Abshere", "Ian Hough", "Matt Kling", 'Derek Kastner']
    gem.files = ['LICENSE', 'README.rdoc'] + 
      Dir.glob(File.join('lib', '**','*.rb'))
    gem.test_files = Dir.glob(File.join('features', '**', '*.rb')) +
      Dir.glob(File.join('features', '**', '*.feature')) +
      Dir.glob(File.join('lib', 'test_support', '**/*.rb'))
    gem.add_development_dependency 'activerecord', '3.0.0.beta4'
    gem.add_development_dependency 'bundler', '>=1.0.0.beta.2'
    gem.add_development_dependency 'cucumber', '=0.8.3'
    gem.add_development_dependency 'jeweler', '=1.4.0'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rdoc'
    gem.add_development_dependency 'rspec', '= 2.0.0.beta.17'
    gem.add_development_dependency 'sniff', '=0.0.11' unless ENV['LOCAL_SNIFF']
    gem.add_dependency 'characterizable', '=0.0.12'
    gem.add_dependency 'data_miner', '= 0.5.2' unless ENV['LOCAL_DATA_MINER']
    gem.add_dependency 'earth', '>=0.0.7'
    gem.add_dependency 'falls_back_on', '= 0.0.2'
    gem.add_dependency 'fast_timestamp', '= 0.0.4'
    gem.add_dependency 'leap', '= 0.4.1' unless ENV['LOCAL_LEAP']
    gem.add_dependency 'summary_judgement', '= 1.3.8'
    gem.add_dependency 'timeframe', '= 0.0.8'
    gem.add_dependency 'weighted_average', '=0.0.4'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: gem install spicycode-rcov"
  end
end

task :test => :features
task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "automobile #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'cucumber'
  require 'cucumber/rake/task'

  Cucumber::Rake::Task.new(:features) do |t|
    t.cucumber_opts = "features --format pretty"
  end
rescue LoadError
  puts 'Cucumber not available. `gem install cucumber`'
end
