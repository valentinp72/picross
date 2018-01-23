require 'rspec/core/rake_task'
require 'simplecov'

# Default task: we run all tests
task :default => :tests

# Tests: we run spec (unit tests) and the coverage tests
task :tests => [:spec, :coverage]

# Spec: Unit tests
RSpec::Core::RakeTask.new(:spec)

# Coverage tests
task :coverage do
	SimpleCov.start do
		add_filter "/spec/"
	end
end
