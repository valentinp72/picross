require 'rake/testtask'

task :default => :test

namespace :test do
  task :coverage do
    require 'simplecov'
    SimpleCov.start 'rails' # feel free to pass block
    Rake::Task["spec"].execute
  end
end

=begin
# task de tests unitaires
Rake::TestTask.new do |t|
	# t.libs << "test"
	# t.test_files = FileList['tests/*_test.rb']
	# t.verbose = true
	require 'simplecov'
	SimpleCov.command_name 'Unit Tests'
	SimpleCov.start do
		add_filter "/spec/"
	end
	
	
end
=end
