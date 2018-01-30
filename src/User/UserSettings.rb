 ##
 # Author :
 # Date : January, 25th 2018
 #

=begin
	This class defines the settings of an user and allows
	to change them.
=end
class UserSettings
	
	## Class variable :
	# * @@validLang - List of supported languages
	
	@@validLang = ['FR']
	
	## Instance variable :
	# * @language
	
	attr_reader :language
	
	# Initialises the language to a default value
	def initialize
		@laguage = @@validLang[0]
	end
	
	# Changes the language value
	def changeLanguage (lang)
		if( @@validLang.include?(lang) )
			@language = lang
		else
			# raise InvalidLanguageError
		end
	end
	
end # UserSettings class