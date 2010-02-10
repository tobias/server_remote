require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "server_remote"
    gem.summary = %Q{A gem that provides script/remote to a project for executing remote commands.}
    gem.email = "tcrawley@gmail.com"
    gem.homepage = "http://github.com/tobias/server_remote"
    gem.authors = ["Tobias Crawley"]
    gem.files = FileList["[A-Z]*.*", "{bin,config,generators,lib,test,spec,script}/**/*"]
    gem.executables = %w{server_remotify}
    gem.add_dependency('simplecli', '>= 0.1.5')
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 For additional settings
  end
  Jeweler::GemcutterTasks.new

rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end


task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "server_remote #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

