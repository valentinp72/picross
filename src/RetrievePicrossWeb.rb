#!/usr/bin/env ruby

require 'open-uri'
require 'nokogiri'
require 'optparse'

require_relative 'PicrossRecognizer'

##
# File          :: RetrievePicrossWeb.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 02/05/2018
# Last update   :: 02/07/2018
# Version       :: 0.1
#
# This program is used to retrieve information about a specific nonogram from http://www.nonograms.org
# This program can return the answer as a .png file
# It also return the size, title and difficulty
#
# Usage:
# 		./RetrievePicrossWeb.rb -l NONOGRAM_LINK
# 		./RetrievePicrossWeb.rb -f INPUT_FILE
# 		./RetrievePicrossWeb.rb -h # for all options

class RetrievePicrossWeb

	##
	# Main program, this class method will be executed when the
	# file RetrievePicrossWeb.rb is executed.
	# * *Returns* :
	#   - the converted Map/Chapter
	def RetrievePicrossWeb.mainProgram()

		arguments = RetrievePicrossWeb.getArgs()

		# The two options are exclusive, it's either one or the other
		if(arguments[:link]) then
			RetrievePicrossWeb.fromURL(arguments[:link])
		elsif (arguments[:file])then
			RetrievePicrossWeb.fromFILE(arguments[:file])
		end

	end

	##
	# Get all the program arguments. The program exit if the program usage
	# is not correct.
	# * *Returns* :
	#   - An Hash, containing arguments and options:
	#     - +:link+ > nonogram's link (default nil)
	#     - +:file+ > file containing several links (defaul nil)
	def RetrievePicrossWeb.getArgs()
		arguments = {}

		# default options values
		arguments[:file] = nil
		arguments[:link] = nil

		parser = OptionParser.new do |opt|
			opt.banner += ' '
			opt.on('-f', '--file INPUT_FILE', 'file containing links for one chapter')    { |o| arguments[:file] = o }
			opt.on('-l', '--link NONOGRAM_LINK', 'nonogram\'s link')    { |o| arguments[:link] = o }
		end
		parser.parse!

		#There shouldn't be any arguments left
		if ARGV.length != 0 then
			puts parser.help, "\n"
			exit
		end
		return arguments
	end

	##
	# Converts the file containing links to several maps
	# * *Arguments* :
	#   - +file+ -> filename containing links
	# * *Returns* :
	#   - Respectively one map for one link
	def RetrievePicrossWeb.fromFILE(file)
		outputFolder = File.dirname(file) + '/'
		File.readlines(file).each do |line|
			RetrievePicrossWeb.fromURL(line.strip, outputFolder)
		end
	end

	##
	# Converts the link to a map
	# * *Arguments* :
	#   - +link+ -> nonogram's link
	# * *Returns* :
	#   - One map
	def RetrievePicrossWeb.fromURL(url, folder=nil)
		html = open(url)
		doc = Nokogiri::HTML(html)

		#Retrieve answer's link
		imgLink = doc.at_css("a#nonogram_answer")['href']
		#Retrieve title of the nonogram
		title = doc.at_css("a#nonogram_answer")['title']

		#Retrieve table containing information about the nonogram
		# - line
		# - column
		# - picture (useless?)
		# - difficulty
		table = doc.at_css("div.content").at_css("table")
		detail = []

		table.search('td').each do |td|
			detail << td
		end


		# We check if picross's name is safe to save
		# Removing special characters and downcasing it
		title=/«([^»]*)»/.match(title.to_s)
		fn = title[1].split(/(?<=.)\.(?=[^.])(?!.*\.[^.])/m)
		fn.map! { |s| s.gsub(/[^a-z0-9\-]+/i, '_') }
		title = fn.join '.'
		title.downcase!


		# Datas that are following are not used at the moment but
		# can become handy in the future

		# Number of column and line
		temp = /([0-9]*)x([0-9]*)/.match(detail.shift)
		# Line is stored first then the column
		# line = temp[1]
		# column = temp[2]

		#Ratio of recognition (is it hard to see what it is or not ?)
		temp = /title="([0-9]*)\/10"/.match(detail.shift.to_s)
		#picture = temp[1]

		#Ratio of difficulty
		temp = /title="([0-9]*)\/10"/.match(detail.shift.to_s)
		difficulty = temp[1]

		# We save the picross's picture,
		# with its name set to the title of the picross
		outputFile = title + ".png"
		if folder != nil then
			outputFile.prepend(folder)
		end
		File.open(outputFile, 'wb') do |fo|
		  fo.write open(imgLink).read
		end

		# We call recognition programm to convert picture to Map Class
		map = PicrossRecognizer.mainProgram(["-d","#{difficulty}","-n","#{title}", outputFile])
		File.delete(outputFile)

		# Returns the map
		return map

	end
end

# Only execute it when it's called from command line
# Not when required
if __FILE__==$0 then
	RetrievePicrossWeb.mainProgram
end
