require 'yaml'

require_relative 'UserSettings'
require_relative 'Chapter'

##
# File			:: User.rb
# Author		:: COHEN Mehdi
# Licence		:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 04/04/2018
#
# This class represents a user's profile

class User

	# The name of the player
	attr_accessor :name

	# The player's settings
	attr_reader :settings

	# Amount of help that the player can spend
	attr_reader :availableHelps

	# Chapters of this user
	attr_reader :chapters

	# The Hash with all the language words related to the user
	attr_writer :lang
	attr_reader :lang

	# Exception when the amount for help is invalid.
	class NegativeAmountException < StandardError; end

	##
	# Creates a new User object
	# * *Arguments* :
	#   - +name+     -> a String representing the user's name
	#   - +chapters+ -> the cahpters for this user
	def initialize(name, chapters)
		@name     = name
		@settings = UserSettings.new(self)
		@availableHelps = 0
		@chapters = chapters
		@lang     = self.languageConfig
	end

	##
	# Load a YAML file corresponding to a language name
	# * *Arguments* :
	#   - +langName+ -> the name of the language to load (english for example)
	# * *Returns* :
	#   - the language converted to Hashs
	def User.loadLang(langName)
		# set path to config file folder
		path = File.dirname(__FILE__) + "/../Config/"
		# Retrieve associated language config file
		configFile = File.expand_path(path + "lang_#{langName}")
		return YAML.load(File.open(configFile))
	end

	##
	# Gets all the languages names available.
	# * *Returns* :
	#   - an Array with all the languages (like [francais, english, ...])
	def User.languagesName
		path = File.dirname(__FILE__) + "/../Config/"
		names = []
		Dir.entries(path).each do |file|
			name = file.partition('lang_')[2]
			names.push(name) if name != ""
		end
		return names
	end

	##
	# Return a default language (english)
	# * *Returns*
	#   - a Hash of the english language
	def User.defaultLang()
		return User.loadLang('english')
	end

	##
	# Return the language of the user. You should not use this method,
	# use instead the +lang+ method, this methods load the file every time you
	# call it.
	# * *Returns*
	#   - a Hash of the user language
	def languageConfig
		return User.loadLang(self.settings.language)
	end

	##
	# Returns the total stars of this user
	# Warning: if you frequently use this method, consider
	# memorizing the value of it, it is calculated every time you call it.
	# * *Returns* :
	#   - the total stars of the user
	def totalStars
		stars = 0
		@chapters.each do |chapter|
			chapter.levels.each do |level|
				bestStat = level.allStat.maxStars
				puts "bestStat:#{bestStat}, lvl:#{level.name}"
				if bestStat != nil then
					stars += bestStat.numberOfStars
				end
	 		end
		end
		return stars
	end

	##
	# Adds an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+ -> a Fixnum representing an amount of help
	# * *Raises* :
	#   - +NegativeAmountException+ if the given amount is negative (use +removeHelp+ instead)
	# * *Returns* :
	#   - the object itself
	def addHelp(amount)
		unless (amount < 0)
			@availableHelps += amount
		else
			raise NegativeAmountException
		end
		return self
	end

	##
	# Removes an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+ -> a Fixnum representing an amount of help
	# * *Raises* :
	#   - +NegativeAmountException+ if it's impossible to remove so much helps
	# * *Returns* :
	#   - the object itself
	def removeHelp (amount)
		unless (@availableHelps - amount < 0)
			@availableHelps -= amount
		else
			raise NegativeAmountException
		end
		return self
	end

	##
	# Iterate through all the chapters of the user
	# * *Yields* :
	#   - a Chapter for each chapter of this user
	# * *Return* :
	#   - the object itself
	def each_chapter
		@chapters.each do |chapter|
			yield chapter
		end
		return self
	end

	##
	# Saves the user into it's file
	# * *Returns* :
	#   - the object itself
	def save
		path = File.expand_path(File.dirname(__FILE__) + '/' + "../Users/User_#{@name}")
		File.open(path, 'w'){|f| f.write(Marshal.dump(self))}
		return self
	end

	##
	# Load a new user from the given file
	# * *Returns* :
	#   - an User
	def User.load(filename)
		return Marshal.load(File.read(filename))
	end

	##
	# Returns an array with all the things to save of the user
	# * *Returns* :
	#   - the user into an array
	def marshal_dump()
		[@name, @settings, @availableHelps, @chapters]
	end

	##
	# Load the array with all the user information into the current user
	# * *Returns* :
	#   - the object itself
	def marshal_load(array)
		@name, @settings, @availableHelps, @chapters = array
		@lang = self.languageConfig
		return self
	end

end
