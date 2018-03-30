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

	# +language+	- the game's displayed language
	attr_reader :language

	# The colors (an Array of String) representing the colors of the hypotheses
	attr_reader :hypothesesColors

	# The binding for keyboardUp
	attr_reader :keyboardUp

	# The binding for keyboardDown
	attr_reader :keyboardDown

	# The binding for keyboardLeft
	attr_reader :keyboardLeft

	# The binding for keyboardRight
	attr_reader :keyboardRight

	# The binding for keyboardClickLeft
	attr_reader :keyboardClickLeft

	# The binding for keyboardClickRight
	attr_reader :keyboardClickRight

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
		@keyboardUp = 122
		@keyboardDown = 115
		@keyboardLeft = 113
		@keyboardRight = 100
		@keyboardClickLeft = 107
		@keyboardClickRight = 108
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
	#   - +oldValue+ -> old bind value
	#   - +newValue+ -> new bind value
	# * *Raises* :
	#   - +InvalidBindException+ if the given value is not know as a current bind
	def changeKeyBoardValue(oldValue, newValue)
		if oldValue == @keyboardUp then
			@keyboardUp = newValue
		elsif oldValue == @keyboardDown then
			@keyboardDown = newValue
		elsif oldValue == @keyboardLeft then
			@keyboardLeft = newValue
		elsif oldValue == @keyboardRight then
			@keyboardRight = newValue
		elsif oldValue == @keyboardClickLeft then
			@keyboardClickLeft = newValue
		elsif oldValue == @keyboardClickRight then
			@keyboardClickRight = newValue
		else
			raise InvalidBindException
		end
	end

	##
	# Checks keyboard bind value
	# * *Arguments* :
	#   - +value+ -> bind value
	def checkNewKey(value)
		if value != @keyboardUp &&
			 value != @keyboardDown &&
			 value != @keyboardLeft &&
			 value != @keyboardRight &&
			 value != @keyboardClickLeft &&
			 value != @keyboardClickRight then
			 	return true
		else
				return false
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
		[@user, @language, @hypothesesColors, @keyboardUp, @keyboardDown, @keyboardLeft, @keyboardRight, @keyboardClickLeft, @keyboardClickRight]
	end

	def marshal_load(array)
		@user, @language, @hypothesesColors, @keyboardUp, @keyboardDown, @keyboardLeft, @keyboardRight, @keyboardClickLeft, @keyboardClickRight = array
		return self
	end

end
