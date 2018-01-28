require 'rspec/core/rake_task'
require 'rdoc/task'

# Default task: we run all tests
task :default => [:tests, :doc]

# tests => we run RSpec (unit tests + code coverage) 
task :tests => [:spec]

# doc => we run rdoc
task :doc => [:rdoc]

# spec => RSpec for unit tests and code coverage with simplecov
RSpec::Core::RakeTask.new(:spec)

# rdoc => RDoc for generating documentation (with hanna-bootstrap generator)
RDoc::Task.new do |rdoc|
	rdoc.main = "README.md"
	rdoc.rdoc_files.include("README.md")
	rdoc.rdoc_files.include("src/*.rb")
	rdoc.rdoc_dir = "doc"
	rdoc.title = "Picross Documentation"
	rdoc.generator = "bootstrap"
end
