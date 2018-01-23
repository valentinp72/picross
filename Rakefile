require 'rspec/core/rake_task'

# Default task: we run all tests
task :default => :tests

# Tests: we run RSpec (unit tests + code coverage) 
task :tests => [:spec]

# RSpec: Unit tests and code coverage with simplecov
RSpec::Core::RakeTask.new(:spec)

