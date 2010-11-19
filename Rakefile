require 'rubygems'

def require_or_fail(gems, message, failure_results_in_death = false)
  gems = [gems] unless gems.is_a?(Array)

  begin
    gems.each { |gem| require gem }
    yield
  rescue LoadError
    puts message
    exit if failure_results_in_death
  end
end

unless ENV['NOBUNDLE']
  message = <<-MESSAGE
In order to run tests, you must:
  * `gem install bundler`
  * `bundle install`
  MESSAGE
  require_or_fail('bundler',message,true) do
    Bundler.with_clean_env do
      Bundler.setup
    end
  end
end

require_or_fail('jeweler', 'Jeweler (or a dependency) not available. Install it with: gem install jeweler') do
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
    gem.add_development_dependency 'activerecord', '~>3'
    gem.add_development_dependency 'bundler', '~>1.0.0'
    gem.add_development_dependency 'cucumber', '~>0.8.3'
    gem.add_development_dependency 'jeweler', '~>1.4.0'
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rdoc'
    gem.add_development_dependency 'rspec', '~>2.0.0.beta.17'
    gem.add_development_dependency 'sniff' unless ENV['LOCAL_SNIFF']
    gem.add_dependency 'emitter', '~>0.3' unless ENV['LOCAL_EMITTER']
    gem.add_dependency 'earth', '~>0.3' unless ENV['LOCAL_EARTH']
  end
  Jeweler::GemcutterTasks.new
end

require_or_fail 'emitter', 'Emitter gem not found, emitter tasks unavailable' do
  require 'emitter/tasks'
  Emitter::Tasks.new.define('automobile')
end

require_or_fail('sniff', 'Sniff gem not found, sniff tasks unavailable') do
  require 'sniff/rake_task'
  Sniff::RakeTask.new(:console) do |t|
    t.earth_domains = :hospitality
  end
end

require_or_fail('cucumber', 'Cucumber gem not found, cucumber tasks unavailable') do
  require 'cucumber/rake/task'

  desc 'Run all cucumber tests'
  Cucumber::Rake::Task.new(:features) do |t|
    if ENV['CUCUMBER_FORMAT']
      t.cucumber_opts = "features --format #{ENV['CUCUMBER_FORMAT']}"
    else
      t.cucumber_opts = 'features --format pretty'
    end
  end

  desc "Run all tests with RCov"
  Cucumber::Rake::Task.new(:features_with_coverage) do |t|
    t.cucumber_opts = "features --format pretty"
    t.rcov = true
    t.rcov_opts = ['--exclude', 'features']
  end

  task :test => :features
  task :default => :test
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lodging #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
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
