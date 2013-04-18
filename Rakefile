require "rake"
require "rubygems/package_task"

require 'bundler'

require "rspec/core"
require "rspec/core/rake_task"


Bundler::GemHelper.install_tasks

task :default => :spec

desc "Run all specs in spec directory"
RSpec::Core::RakeTask.new(:spec)

require "yard"
require "yard/rake/yardoc_task"

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = []
  t.options << '--debug' << '--verbose' if $trace
end
