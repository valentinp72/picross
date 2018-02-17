require 'rspec/core/rake_task'
require 'rdoc/task'

# the application output name
APPLICATION_NAME    = 'Rubycross'

# change this constant when you wan to change the Rubycross app version
BUILD_VERSION      = '0.0.1'

# the ruby build version (all OS binaries should be downloaded in RUBY_BIN_ROOT)
RUBY_BUILD_VERSION = '2.2.2'

# the main build folder
BUILD_ROOT         = 'build/'
BUILD_OUTPUT       = BUILD_ROOT + 'output/' + BUILD_VERSION + '/'
BUILD_VENDOR       = BUILD_ROOT + 'vendor/'

# the ouput folders for applications
BUILD_MAC_OS       = 'macOS_'        + BUILD_VERSION + '/'
BUILD_LINUX_x86    = 'linux_x86_'    + BUILD_VERSION + '/'
BUILD_LINUX_x86_64 = 'linux_x86_64_' + BUILD_VERSION + '/'
BUILD_ALL_FOLDERS  = [BUILD_MAC_OS, BUILD_LINUX_x86, BUILD_LINUX_x86_64]

# application source folder
SOURCE_FOLDER      = 'src/'
OTHER_FOLDERS      = ['Users/']
LOG_FOLDER_NAME    = 'logs/'
GEMFILES_PATHS     = ['Gemfile', 'Gemfile.lock']

# ruby file to be excecuted by the application
EXECUTABLE_RB      = SOURCE_FOLDER + 'UI/Application.rb'

# application configuration
MAC_OS_INFO_PLIST  = BUILD_ROOT + 'config/Info.plist'
MAC_OS_APP_ICON    = BUILD_ROOT + 'config/icon.icns'
EXECUTABLE_SCRIPT  = BUILD_ROOT + 'config/Rubycross'
EXECUTABLE_CONTENT = 
%Q[#!/usr/bin/env bash

# quit everything if something fail
set -e

SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

CURRENTDATE=`date '+%Y-%m-%d_%H_%M_%S'`
OUTPUT_FILE="$CURRENTDATE.log"

$SELFDIR/ruby/bin/ruby -rbundler/setup $SELFDIR/#{EXECUTABLE_RB} > $SELFDIR/#{LOG_FOLDER_NAME}$OUTPUT_FILE 2>&1

]
BUNDLE_CONFIG_CONTENT =
%Q[BUNDLE_PATH: .
BUNDLE_WITHOUT: development
BUNDLE_DISABLE_SHARED_GEMS: '1'
]

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

	# check if vendor folder is present
	if not File.exist?(BUILD_VENDOR) then
		raise "Error: vendor files not presents. Install gems with `rake build_vendor`"
	end

	# create the executable script
	File.write(EXECUTABLE_SCRIPT, EXECUTABLE_CONTENT)
	FileUtils.chmod_R('u+x', EXECUTABLE_SCRIPT)

end

# generate vendor (gems)
task :build_vendor do
	# download all gems in the vendor folder
	sh "env BUNDLE_IGNORE_CONFIG=1 bundle install --path #{BUILD_VENDOR} --without development"
	
	# add Gemfile and Gemfile.lock
	GEMFILES_PATHS.each do |gemFile|
		FileUtils.cp(gemFile, BUILD_VENDOR)
	end

	# remove cache files
	sh "rm -f #{BUILD_VENDOR}*/*/cache/*"

	# add .bundle folder with config inside
	bundlePath = BUILD_VENDOR + '.bundle/'
	FileUtils.mkdir_p(bundlePath)
	File.write(bundlePath + 'config', BUNDLE_CONFIG_CONTENT)

end

# macOS application build
task :build_macOS do
	if not File.exists?(MAC_OS_INFO_PLIST) then
		raise "Error: #{MAC_OS_INFO_PLIST} not found!\n\n"
	end

	# main output file for macOS
	outputFolder  = BUILD_OUTPUT + BUILD_MAC_OS + APPLICATION_NAME + '.app/'
	outputFolder += 'Contents/'
	FileUtils.mkdir_p(outputFolder)

	# application informations
	FileUtils.cp(MAC_OS_INFO_PLIST, outputFolder + 'Info.plist')

	# all sources
	sourceFolder = outputFolder + 'MacOS/'
	FileUtils.mkdir_p(sourceFolder)

	FileUtils.cp_r(RUBY_BIN_MAC_OS, sourceFolder + 'ruby/') # ruby binaries
	FileUtils.cp_r(BUILD_VENDOR,    sourceFolder) # gems
	FileUtils.cp_r(SOURCE_FOLDER,   sourceFolder) # the souce folder
	FileUtils.cp_r(OTHER_FOLDERS,   sourceFolder) # all other folders that are not sources
	FileUtils.cp(EXECUTABLE_SCRIPT, sourceFolder) # the executable

	FileUtils.mkdir_p(sourceFolder + LOG_FOLDER_NAME) # log folder


	# all resources
	resourcesFolder = outputFolder + 'Resources/'
	FileUtils.mkdir_p(resourcesFolder)
	FileUtils.cp(MAC_OS_APP_ICON, resourcesFolder)


end
