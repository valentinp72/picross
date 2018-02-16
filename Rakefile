require 'rspec/core/rake_task'
require 'rdoc/task'

# the application output name
APPLICATION_NAME   = 'Ruþycross'

# change this constant when you wan to change the Rubycross app version
BUILD_VERSION      = '0.0.1'

# the ruby build version (all OS binaries should be downloaded in RUBY_BIN_ROOT)
RUBY_BUILD_VERSION = '2.2.2'

# the main build folder
BUILD_ROOT         = 'build/'
BUILD_OUTPUT       = BUILD_ROOT + 'output/' + BUILD_VERSION + '/'

# the ouput folders for applications
BUILD_MAC_OS       = 'macOS_'        + BUILD_VERSION + '/'
BUILD_LINUX_x86    = 'linux_x86_'    + BUILD_VERSION + '/'
BUILD_LINUX_x86_64 = 'linux_x86_64_' + BUILD_VERSION + '/'
BUILD_ALL_FOLDERS  = [BUILD_MAC_OS, BUILD_LINUX_x86, BUILD_LINUX_x86_64]

# application source folder
SOURCE_FOLDER      = 'src/'
OTHER_FOLDERS      = ['Users/']

# ruby file to be excecuted by the application
EXECUTABLE_RB      = SOURCE_FOLDER + 'UI/Application.rb'

# application configuration
MAC_OS_INFO_PLIST  = BUILD_ROOT + 'config/Info.plist'
MAC_OS_APP_ICON    = BUILD_ROOT + 'config/icon.icns'
EXECUTABLE_SCRIPT  = BUILD_ROOT + 'config/Ruþycross'
EXECUTABLE_CONTENT = 
"#!/usr/bin/env bash

cd `dirname $0`
#ruby/bin/ruby #{EXECUTABLE_RB}
/Users/Valentin/.rbenv/shims/ruby #{EXECUTABLE_RB}
"

# the Ruby binaries folder
RUBY_BIN_ROOT         = BUILD_ROOT    + 'ruby/' + RUBY_BUILD_VERSION + '/'
RUBY_BIN_MAC_OS       = RUBY_BIN_ROOT + 'osx/'
RUBY_BIN_LINUX_x86    = RUBY_BIN_ROOT + 'linux_x86/'
RUBY_BIN_LINUX_x86_64 = RUBY_BIN_ROOT + 'linux_x86_64/'
RUBY_BIN_ALL_FOLDERS  = [RUBY_BIN_MAC_OS, RUBY_BIN_LINUX_x86, RUBY_BIN_LINUX_x86_64]

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

# application build for all OS
task :build_all => [:build_prepare, :build_macOS]

# preparation of applications building
task :build_prepare do
	# clear the output folder
	FileUtils.rm_rf(BUILD_OUTPUT)

	# create all output folders
	BUILD_ALL_FOLDERS.each do |os|
		FileUtils.mkdir_p(BUILD_OUTPUT + os)
	end

	# check if all ruby binaries are present
	RUBY_BIN_ALL_FOLDERS.each do |rubyBin|
		if not File.exist?(rubyBin) then
			raise "Error: no such ruby binary #{rubyBin}\nPlease download it from:\n\thttps://traveling-ruby.s3-us-west-2.amazonaws.com/list.html\n\n"
		end
	end

	# create the executable script
	File.write(EXECUTABLE_SCRIPT, EXECUTABLE_CONTENT)
	FileUtils.chmod_R('u+x', EXECUTABLE_SCRIPT)

end

# macOS application build
task :build_macOS do
	if not File.exists?(MAC_OS_INFO_PLIST) then
		raise "Error: #{MAC_OS_INFO_PLIST} not found!\n\n"
	end

	outputFolder  = BUILD_OUTPUT + BUILD_MAC_OS + APPLICATION_NAME + '.app/'
	outputFolder += 'Contents/'

	FileUtils.mkdir_p(outputFolder)
	FileUtils.cp(MAC_OS_INFO_PLIST, outputFolder + 'Info.plist')

	sourceFolder = outputFolder + 'MacOS/'
	FileUtils.mkdir_p(sourceFolder)
	FileUtils.cp_r(RUBY_BIN_MAC_OS, sourceFolder + 'ruby/')
	FileUtils.cp_r(SOURCE_FOLDER,   sourceFolder)
	FileUtils.cp_r(OTHER_FOLDERS,   sourceFolder)
	FileUtils.cp(EXECUTABLE_SCRIPT, sourceFolder)

	resourcesFolder = outputFolder + 'Resources/'
	FileUtils.mkdir_p(resourcesFolder)
	FileUtils.cp(MAC_OS_APP_ICON, resourcesFolder)

end
