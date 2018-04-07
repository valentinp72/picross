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
	@@validLang = ["francais", "english"]

	# The game's displayed language
	attr_reader :language

	# The colors (an Array of String) representing the colors of the hypotheses
	attr_reader :hypothesesColors

	# The picrros keyboard binding 
	attr_reader :picrossKeys

	# Exception when the chosen language is not known.
	class InvalidLanguageException < StandardError; end

	# Exception when the old bind value is not valid.
	class InvalidBindException < StandardError; end

	##
	# Initialises the settings to default values
	def initialize(user)
		@user = user
		@language         = @@validLang[0]
		@hypothesesColors = ["#000000", "#eb2f06", "#f6b93b", "#1e3799", "#079992"]
		
		# Hash of all available keys on the picross
		# Since Ruby 1.9, Hash order is maintained:
		# https://www.igvita.com/2009/02/04/ruby-19-internals-ordered-hash/
		@picrossKeys      = {
			"up"          => 122,
			"down"        => 115,
			"left"        => 113,
			"right"       => 100,
			"click-left"  => 107,
			"click-right" => 108
		}
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
			@user.lang = @user.languageConfig
		else
			 raise InvalidLanguageException
		end
		return self
	end

	##
	# Changes keyboard bind
	# * *Arguments* :
	#   - +value+ -> new bind value
	#   - +index+ -> index value
	# * *Raises* :
	#   - +InvalidBindException+ if the given value is not know as a current bind
	def changeKeyBoardValue(value, keyName)
		if @picrossKeys.include?(keyName) then
			@picrossKeys[keyName] = value
		else
			raise InvalidBindException
		end
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
					if self.validColor?(newColors[i]) then
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
		[@user, @language, @hypothesesColors, @picrossKeys]
	end

	def marshal_load(array)
		@user, @language, @hypothesesColors, @picrossKeys = array
		return self
	end

end
