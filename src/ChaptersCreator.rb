#!/usr/bin/env ruby

require 'yaml'
require 'optparse'

require_relative 'RetrievePicrossWeb'
require_relative 'Chapter'
require_relative 'Map'

##
# File          :: ChaptersCreator.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 03/01/2018
# Last update   :: 03/01/2018
# Version       :: 0.1
#
# This program is used to create all the chapters for
# the game from a single YAML configuration file.
# This file must contains all the chapters and the
# links to the Picross grid (from nonograms.org).
#
# Usage:
# 		./ChaptersCreator.rb <chapters file.yml>
# 		./ChaptersCreator.rb -h # for all options

class ChaptersCreator

	# Exception when the config file does not exists.
	class ConfigFileNotFoundException < StandardError; end
	
	# Exception when there is a syntax error inside the config file
	class ConfigFileSyntaxException < StandardError; end
	
	##
	# Main program, this class method will be executed when the
	# file ChaptersCreator.rb is executed.
	# * *Returns* :
	#   - the converted Chapter
	def ChaptersCreator.mainProgram()
		arguments = ChaptersCreator.getArgs()
		ChaptersCreator.createFromFile(arguments[:configFile])
	end

	def ChaptersCreator.createFromFile(filename)
		if File.exists?(filename) then
			datas    = YAML.load_file(filename)
			outputF  = File.dirname(filename) + '/'
			chapterI = 1
			datas.each do |chapterName, values|
				realName = chapterI.to_s + '_' + chapterName
				chap = ChaptersCreator.createChapter(realName, values, outputF)
				chap.save(outputF)	
			end
		else
			raise ConfigFileNotFoundException
		end
	end

	def ChaptersCreator.createChapter(chapterName, values, outputFolder)
		stars  = ChaptersCreator.getFromHash(values[0], "stars")  
		links  = ChaptersCreator.getFromHash(values[1], "links")
		levels = Array.new()
		links.each do |link|
			map = RetrievePicrossWeb.fromURL(link, outputFolder, false)
			levels.push(map)
		end
		return Chapter.new(chapterName, levels, stars)
	end

	def ChaptersCreator.getFromHash(element, neededKey)
		if not element.kind_of?(Hash) then
			raise ConfigFileSyntaxException.new "Waiting for a Hash" 
		end
		if not element.has_key?(neededKey) then
			raise ConfigFileSyntaxException.new "Waiting for #{neededKey} inside the Hash"
		end
		return element[neededKey]
	end

	##
	# Get all the program arguments. The program exit 
	# if the program usage is not correct.
	# * *Returns* :
	#   - An Hash, containing arguments and options:
	#     - +:configFile+ > folder containing all files needed
	def ChaptersCreator.getArgs()
		arguments = {}

		# default options values
		arguments[:verbose] = false

		parser = OptionParser.new do |opt|
			opt.banner += ' <chapters file.yml>'
			opt.on('-v', '--verbose', 'Verbose mode'){ |o| arguments[:verbose] = o }
		end
		parser.parse!

		#There should be only one argument -> config file name
		if ARGV.length != 1 then
			puts parser.help, "\n"
			raise OptionParser::MissingArgument, ' <chapters file.yml>'
		end
		arguments[:configFile] = ARGV.first

		return arguments
	end

end

# Only execute it when it's called from command line
# Not when required
if __FILE__ == $0 then
	ChaptersCreator.mainProgram
end
