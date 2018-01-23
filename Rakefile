require 'rspec/core/rake_task'
require 'simplecov'

task :default => :tests

task :tests => [:spec, :coverage]

RSpec::Core::RakeTask.new(:spec)

desc "Run the test coverage"
task :coverage do
	SimpleCov.start do
		add_filter "/spec/"
	end
end
