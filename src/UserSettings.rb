##
# File			:: UserSettings.rb
# Author		:: PASTOURET Gilles
# Licence		:: MIT Licence
# Creation date	:: 02/12/2018
# Last update	:: 02/12/2018
#
# This class defines the settings of an user
#

class UserSettings
	# +validLang+ - List of supported languages
	@@validLang = ["francais","english"]

<<<<<<< HEAD
	@@validLang = ["francais","english"]

	## Instance variable :
=======
>>>>>>> 20a1e34b6a787a5dfb8e72b161abc7258d0228ab
	# +language+	- the game's displayed language
	attr_reader :language

	# The colors (an Array of String) representing the colors of the hypotheses
	attr_reader :hypothesesColors
	
	# Exception when the chosen language is not known.
	class InvalidLanguageException < StandardError; end

	##
	# Initialises the settings to default values
	def initialize()
		@language         = @@validLang[0]
		@hypothesesColors = ["#000000", "#eb2f06", "#f6b93b", "#1e3799", "#079992"]
	end

	##
	# Changes the language value
	# * *Arguments* :
	#   - +lang+ -> the new language
	# * *Raises* :
	#   - +InvalidLanguageException+ if the given language is not know as a language
	def language=(lang)
		if( @@validLang.include?(lang) )
			@language = lang
		else
			 raise InvalidLanguageException
		end
		return self
	end

	##
	# Changes the color of the hypotheses
	# * *Arguments* :
	#   - +newColors+ -> an array of string, each string representing 
	#   an 	hexadecimal color.
	#   To be changed, +newColors+ needs to be valid:
	#   * needs to be an Array of Strings
	#   * the array must me the same length of the default one
	#   * the colors must be corrects: 7 charaters length, starting with a #
	def hypothesesColors=(newColors)
		if newColors.kind_of?(Array) then
			if newColors.length == @hypothesesColors.length then
				newColors.each_index do |i|
					if newColors[i].validColor? then
						@hypothesesColors[i] = newColors[i]
					end
				end
			end
		end
		return self
	end

	##
	# Returns true if the given color is a valid hex color.
	# The color must start with the #
	# * *Arguments* :
	#   - +color+ -> the color to check
	# * *Returns* :
	#   - true if the color is valid, false otherwise
	def validColor?(color)
		if color.kind_of?(String) then
			if color[0] == "#" && color.length == 7 then
				hex = color[1..color.length]
				# regular expr, \H matches non-hex digit
				return !hex[/\H/]
			end
		end
		return false
	end

	def marshal_dump()
		[@language, @hypothesesColors]
	end

	def marshal_load(array)
		@language, @hypothesesColors = array
		return self
	end

end
