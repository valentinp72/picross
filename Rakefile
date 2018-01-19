require 'rake/testtask'

task :default => :test

# task de tests unitaires
Rake::TestTask.new do |t|
	t.libs << "test"
	t.test_files = FileList['tests/*_test.rb']
	t.verbose = true
end
