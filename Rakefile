require 'rspec/core/rake_task'
require 'rdoc/task'

###########################
#                         #
# MAIN PROJECT RAKE TASKS #
#                         #
###########################

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
	rdoc.rdoc_files.include("src/**/*.rb")
	rdoc.rdoc_dir = "doc"
	rdoc.title = "Picross Documentation"
	rdoc.generator = "bootstrap"
end


#################################
#                               #
# APPLICATION PLATFORM BUILDING #
#                               #
#################################

#############
# CONSTANTS #
#############

# the application output name
APPLICATION_NAME    = 'Rubycross'

# change this constant when you wan to change the Rubycross app version
BUILD_VERSION      = '1.0.1'

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
OTHER_FOLDERS      = ['Users/', 'Config/']
LOG_FOLDER_NAME    = 'logs/'
GEMFILES_PATHS     = ['Gemfile', 'Gemfile.lock']

# ruby file to be excecuted by the application
EXECUTABLE_RB      = SOURCE_FOLDER + 'Application.rb'

LINUX_RESOURCES    = ['lib/']

LINUX_X86_64_PATH  = BUILD_ROOT + 'config/linux_x86_64/'
LINUX_X86_64_LIBS  = LINUX_X86_64_PATH + 'linux_x86_64_required_dylib.txt'

# macos application configuration
MAC_OS_INFO_PLIST  = BUILD_ROOT + 'config/macOS/Info.plist'
MAC_OS_RSCR_PATH   = BUILD_ROOT + 'config/macOS/Resources/'
MAC_OS_RESOURCES   = ['icon.icns', 'lib/', 'share/']
MAC_OS_TO_DMG      = BUILD_ROOT + 'config/macOS/dmg.json'
MAC_OS_DYLIBS      = BUILD_ROOT + 'config/macOS/macOS_required_dylib.txt'
MAC_OS_TYPELIBS    = BUILD_ROOT + 'config/macOS/macOS_required_typelib.txt'
MAC_OS_ENV_VARS    = {
	"DYLD_LIBRARY_PATH" => "$ROOT/Resources/lib/",
	"GI_TYPELIB_PATH"   => "$ROOT/Resources/lib/"
}
MAC_OS_DYLIB_LINKS = {
	"libepoxy.0.dylib" => "libepoxy.dylib",
	"libgraphite2.3.0.1.dylib" => "libgraphite2.3.dylib"
}

# Content of the main executable
EXECUTABLE_NAME  = 'Rubycross'
EXECUTABLE_CONTENT = 
%Q[#!/usr/bin/env bash

# quit everything if something fail
set -e

SELFDIR="`dirname \"$0\"`"
SELFDIR="`cd \"$SELFDIR\" && pwd`"

# Tell Bundler where the Gemfile and gems are.
export BUNDLE_GEMFILE="$SELFDIR/vendor/Gemfile"
unset BUNDLE_IGNORE_CONFIG

# Create an ouput log file name, based on the date and time
CURRENTDATE=`date '+%Y-%m-%d_%H_%M_%S'`
OUTPUT_FILE="$CURRENTDATE.log"
]

# https://github.com/jralls/gtk-mac-bundler
EXECUTABLE_MAC_OS_ADDITIONAL =
%Q[
tmp="$SELFDIR"
bundle=`dirname "$tmp"`
bundle_contents="$bundle"
bundle_res="$bundle_contents"/Resources
bundle_lib="$bundle_res"/lib
bundle_bin="$bundle_res"/bin
bundle_data="$bundle_res"/share
bundle_etc="$bundle_res"/etc

export DYLD_LIBRARY_PATH="$bundle_lib"
export XDG_CONFIG_DIRS="$bundle_etc"/xdg
export XDG_DATA_DIRS="$bundle_data"
export GTK_DATA_PREFIX="$bundle_res"
export GTK_EXE_PREFIX="$bundle_res"
export GTK_PATH="$bundle_res"
export GTK2_RC_FILES="$bundle_etc/gtk-2.0/gtkrc"
export GTK_IM_MODULE_FILE="$bundle_etc/gtk-2.0/gtk.immodules"
#N.B. When gdk-pixbuf was separated from Gtk+ the location of the
#loaders cache changed as well. Depending on the version of Gtk+ that
#you built with you may still need to use the old location:
#export GDK_PIXBUF_MODULE_FILE="$bundle_etc/gtk-2.0/gdk-pixbuf.loaders"
export GDK_PIXBUF_MODULE_FILE="$bundle_lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
export PANGO_LIBDIR="$bundle_lib"
export PANGO_SYSCONFDIR="$bundle_etc"
]

EXECUTABLE_LINUX_ADDITIONAL =
%Q[
tmp="$SELFDIR"
bundle=`dirname "$tmp"`
bundle_contents="$bundle"
bundle_res="$bundle_contents"
bundle_lib="$bundle_res"/lib
bundle_bin="$bundle_res"/bin
bundle_data="$bundle_res"/share
bundle_etc="$bundle_res"/etc

export LD_LIBRARY_PATH="$bundle_lib"
export XDG_CONFIG_DIRS="$bundle_etc"/xdg
export XDG_DATA_DIRS="$bundle_data"
export GTK_DATA_PREFIX="$bundle_res"
export GTK_EXE_PREFIX="$bundle_res"
export GTK_PATH="$bundle_res"
export GTK2_RC_FILES="$bundle_etc/gtk-2.0/gtkrc"
export GTK_IM_MODULE_FILE="$bundle_etc/gtk-2.0/gtk.immodules"
#N.B. When gdk-pixbuf was separated from Gtk+ the location of the
#loaders cache changed as well. Depending on the version of Gtk+ that
#you built with you may still need to use the old location:
#export GDK_PIXBUF_MODULE_FILE="$bundle_etc/gtk-2.0/gdk-pixbuf.loaders"
export GDK_PIXBUF_MODULE_FILE="$bundle_lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
export PANGO_LIBDIR="$bundle_lib"
export PANGO_SYSCONFDIR="$bundle_etc"
]

EXECUTABLE_COMMAND =
%Q[
$SELFDIR/ruby/bin/ruby -rbundler/setup $SELFDIR/#{EXECUTABLE_RB} > $SELFDIR/#{LOG_FOLDER_NAME}$OUTPUT_FILE 2>&1
]

# bundle config file (force to use local gems)
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

# application build for all OS
RUBY_BIN_ALL_FOLDERS  = [RUBY_BIN_MAC_OS, RUBY_BIN_LINUX_x86, RUBY_BIN_LINUX_x86_64]

# the ruby binaries links
RUBY_URL_MAC_OS       = "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-osx.tar.gz"
RUBY_URL_LINUX_x86    = "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-linux-x86.tar.gz"
RUBY_URL_LINUX_x86_64 = "http://d6r77u77i8pq3.cloudfront.net/releases/traveling-ruby-20150715-2.2.2-linux-x86_64.tar.gz" 


###################
# Main Rake tasks #
###################

# build all packages for all platforms
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
			raise "Error: no such ruby binary #{rubyBin}\nPlease download it with `rake build_getRuby`\n\n"
		end
	end

	# check if vendor folder is present
	if not File.exist?(BUILD_VENDOR) then
		raise "Error: vendor files not presents. Install gems with `rake build_vendor`"
	end


end

# download ruby binaries
task :build_getRuby do

	# start by removing the old ruby binaries if exist
	FileUtils.rm_rf(RUBY_BIN_ROOT)

	# then re-create the destination folders
	FileUtils.mkdir_p(RUBY_BIN_MAC_OS)
	FileUtils.mkdir_p(RUBY_BIN_LINUX_x86)
	FileUtils.mkdir_p(RUBY_BIN_LINUX_x86_64)

	# get the given archive with wget, and untar-it
	# auto-remove the archive
	def wget_untar(tarURL, destinationFolder, osNameInfo)
		puts "Getting #{osNameInfo} ruby binaries..."
		sh "wget -qO- #{tarURL} | tar xz -C #{destinationFolder}"
		puts "Done!\n\n"
	end

	wget_untar(RUBY_URL_MAC_OS,       RUBY_BIN_MAC_OS, "macOS")
	wget_untar(RUBY_URL_LINUX_x86,    RUBY_BIN_LINUX_x86, "linux_x86")
	wget_untar(RUBY_URL_LINUX_x86_64, RUBY_BIN_LINUX_x86_64, "linux_x86_64")

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


##################
# Plaform builds #
##################

# macOS application build
task :build_macOS do
	if not File.exists?(MAC_OS_INFO_PLIST) then
		raise "Error: #{MAC_OS_INFO_PLIST} not found!\n\n"
	end

	# main output file for macOS
	outputFolder  = BUILD_OUTPUT + BUILD_MAC_OS + APPLICATION_NAME + '.app/'
	outputFolder += 'Contents/'
	FileUtils.mkdir_p(outputFolder)

	# to dmg configuration file
	FileUtils.cp(MAC_OS_TO_DMG, BUILD_OUTPUT + BUILD_MAC_OS + 'dmg.json')

	# application informations
	FileUtils.cp(MAC_OS_INFO_PLIST, outputFolder + 'Info.plist')

	# all sources folder
	sourceFolder = outputFolder + 'MacOS/'
	FileUtils.mkdir_p(sourceFolder)

	rubyFolder = sourceFolder + 'ruby/'
	FileUtils.cp_r(RUBY_BIN_MAC_OS, rubyFolder)             # ruby binaries
	FileUtils.cp_r(BUILD_VENDOR,    sourceFolder)           # gems
	FileUtils.cp_r(SOURCE_FOLDER,   sourceFolder)           # the souce folder
	FileUtils.cp_r(OTHER_FOLDERS,   sourceFolder)           # all other folders that are not sources
	FileUtils.mkdir_p(sourceFolder + LOG_FOLDER_NAME)       # log folder

	# create the executable script
	open(sourceFolder + EXECUTABLE_NAME, 'w') do |exec|
		
		exec.puts EXECUTABLE_CONTENT
		
		# as we are on macOS, we include the commands for the bundled app
		exec.puts EXECUTABLE_MAC_OS_ADDITIONAL

		exec.puts EXECUTABLE_COMMAND
	end
	FileUtils.chmod_R('u+x', sourceFolder + EXECUTABLE_NAME)

	# all resources
	resourcesFolder = outputFolder + 'Resources/'
	FileUtils.mkdir_p(resourcesFolder)
	MAC_OS_RESOURCES.each do |rsrc|
		FileUtils.cp_r(MAC_OS_RSCR_PATH + rsrc, resourcesFolder)
	end


	libFolder = resourcesFolder + 'lib/'
	FileUtils.mkdir_p(libFolder)
	
	# get all needed dylib and add them to Resources/lib
	File.readlines(MAC_OS_DYLIBS).each do |line|
		# ignore # comments
		if not line[0] == '#' then
			file = line.strip
			FileUtils.cp_r(file, libFolder + File.basename(file))
		end
	end

	# we add all the needed links to some dylib
	MAC_OS_DYLIB_LINKS.each do |source, target|
		FileUtils.ln_s(source, libFolder + target)
	end

	# get all needed typelib and add them to Resources/lib
	File.readlines(MAC_OS_TYPELIBS).each do |line|
		# ignore # comments
		if not line[0] == '#' then
			file = line.strip
			FileUtils.cp_r(file, libFolder + File.basename(file))
		end
	end

	# add macOS environment variables to the ruby binary
	# due to SIP, on macOS 10.11+, environment variables 
	# like DYLD_LIBRARY_PATH are no longer propagated on 
	# shells scripts with exec, so we need to add variables 
	# just before the real binary gets executed
	# 
	# https://en.wikipedia.org/wiki/System_Integrity_Protection
	# https://github.com/oracle/node-oracledb/issues/231
	rubyFile = rubyFolder + 'bin/ruby'

	# we get an array containg every line of the original file,
	# and we add our lines
	linesRubyFile = File.readlines(rubyFile)
	MAC_OS_ENV_VARS.each do |var, value|
		# add our variables after the fifth line (the sixth being the exec command)
		linesRubyFile.insert(5, "export #{var}=#{value}")
	end
	# the we write back everything into the file
	File.open(rubyFile, "w") do |file|
		linesRubyFile.each do |line|
			file.puts line
		end
	end
	
	# then we need to add the resource folder in the ruby folder
	# => symbolic link
	FileUtils.ln_s("../../Resources", rubyFolder)

	# Remove users
	Dir.chdir(sourceFolder + 'Users') do
		sh "rm User_*"
	end

	# Remove .DS_Store
	Dir.chdir(BUILD_OUTPUT + BUILD_MAC_OS + APPLICATION_NAME + '.app') do
		sh 'find . -name ".DS_Store" -exec rm "{}" \;'
	end

	puts "Done!"

	# we create the DMG and zip
	Dir.chdir(BUILD_OUTPUT + BUILD_MAC_OS) do
		puts "Exporting to zip..."
		sh "zip -q -r #{APPLICATION_NAME}.zip #{APPLICATION_NAME}.app"
		puts "Exporting to DMG..."
		sh "appdmg dmg.json #{APPLICATION_NAME}.dmg"
	end
end

# linux_x86 application build
task :build_linux_x86 do


end

# linux_x86_64 application build
task :build_linux_x86_64 do

	outputFolder = BUILD_OUTPUT + BUILD_LINUX_x86_64 + APPLICATION_NAME + "/"
	FileUtils.mkdir_p(outputFolder)

	# all sources folder
	sourceFolder = outputFolder + 'sources/'
	FileUtils.mkdir_p(sourceFolder)

	rubyFolder = sourceFolder + 'ruby/'
	FileUtils.cp_r(RUBY_BIN_LINUX_x86_64, rubyFolder)       # ruby binaries
	FileUtils.cp_r(BUILD_VENDOR,    sourceFolder)           # gems
	FileUtils.cp_r(SOURCE_FOLDER,   sourceFolder)           # the souce folder
	FileUtils.cp_r(OTHER_FOLDERS,   sourceFolder)           # all other folders that are not sources
	FileUtils.mkdir_p(sourceFolder + LOG_FOLDER_NAME)       # log folder

	# create the executable script
	open(sourceFolder + EXECUTABLE_NAME, 'w') do |exec|
		
		exec.puts EXECUTABLE_CONTENT
		
		# as we are on macOS, we include the commands for the bundled app
		exec.puts EXECUTABLE_LINUX_ADDITIONAL

		exec.puts EXECUTABLE_COMMAND
	end
	FileUtils.chmod_R('u+x', sourceFolder + EXECUTABLE_NAME)

	libFolder = sourceFolder + 'lib/'
	FileUtils.mkdir_p(libFolder)
	
	# get all needed lib and add them to lib
	File.readlines(LINUX_X86_64_LIBS).each do |line|
		# ignore # comments
		if not line[0] == '#' then
			file = line.strip
			FileUtils.cp_r(file, libFolder + File.basename(file))
		end
	end
	
	# add other resources
	LINUX_RESOURCES.each do |rsrc|
		FileUtils.cp_r(LINUX_X86_64_PATH + rsrc, libFolder)
	end

end

