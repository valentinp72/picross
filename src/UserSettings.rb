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
	## Class variables :
	# +validLang+ - List of supported languages
	
	@@validLang = ['FR']
	
	## Instance variable :
	# +language+	- the game's displayed language
	
	attr_reader :language
	
	##
	# Initialises the language to a default value
	#
	def initialize()
		@language = @@validLang[0]
	end
	
	##
	# Changes the language value
	#
	def language= (lang)
		if( @@validLang.include?(lang) )
			@language = lang
		else
			 raise InvalidLanguageException
		end
	end
	
end