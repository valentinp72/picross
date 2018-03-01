#!/usr/bin/env ruby

require 'yaml'
require 'optparse'

require_relative 'Chapter'
require_relative 'Map'

##
# File          :: ChapterCreator.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/17/2018
# Last update   :: 02/17/2018
# Version       :: 0.1
#
# This program is used to create a chapter
# It takes a folder as parameter. This folder must contain a config file
# and all .map file needed to create the chapter
# It returns a .chapter file
#
# Usage:
# 		./ChapterCreator.rb FOLDER
# 		./ChapterCreator.rb -h # for all options
class ChapterCreator

	# Exception when the config file does not exists.
	class ConfigFileNotFoundException < StandardError; end

	##
	# Main program, this class method will be executed when the
	# file ChapterCreator.rb is executed.
	# * *Returns* :
	#   - the converted Chapter
	def ChapterCreator.mainProgram()

		arguments = ChapterCreator.getArgs()
		@path = arguments[:folder]

		# Raise an error if config file doesn't exist
		raise ConfigFileNotFoundException unless File.exists?(@path + "config.yml")
		config = YAML.load(File.open(@path + "config.yml"))

		# Retrieve information from config file
		title = config["chapter"]["title"]
		starsRequired = config["chapter"]["stars"]
		isUnlocked = config["chapter"]["unlocked"]

		# Retrieve levelname to load
		levelName = config["chapter"]["levels"]
		levels = Array.new()

		# Load each map and add it to the chapter
		levelName.each do |l|
			levels.push(Map.load(@path + l + ".map"))
		end

		# Create new chapter
		chap = Chapter.new(title,levels,starsRequired,isUnlocked)

		print chap if arguments[:verbose]

		# Save the new chapter in the folder
		chap.save(@path)
	end

	##
	# Get all the program arguments. The program exit if the program usage
	# is not correct.
	# * *Returns* :
	#   - An Hash, containing arguments and options:
	#     - +:folder+ > folder containing all files needed
	def ChapterCreator.getArgs()
		arguments = {}

		# default options values
		arguments[:verbose] = false

		parser = OptionParser.new do |opt|
			opt.banner += ' <folder>'
			opt.on('-v', '--verbose', 'Verbose mode'){ |o| arguments[:verbose] = o }
		end
		parser.parse!

		#There should be only one argument -> folder name
		if ARGV.length != 1 then
			puts parser.help, "\n"
			raise OptionParser::MissingArgument, ' <folder>'
		end
		arguments[:folder] = ARGV.first

		return arguments
	end
end

# Only execute it when it's called from command line
# Not when required
if __FILE__ == $0 then
	ChapterCreator.mainProgram
end
