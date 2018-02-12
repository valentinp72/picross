load 'UserSettings.rb'
require_relative 'UserSettings'

##
# File			:: User.rb
# Author		:: COHEN Mehdi
# Licence		:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 02/12/2018
#
# This class represents a user's profile
# 
class User

	# +name+		- player's name
	# +settings+	- player's settings

	attr_accessor :name
	private_class_method :new

	##
	# Creates a new User object
	# * *Arguments* :
	#   - +name+		-> a String representing the user's name
	def User.create(name)
		new(name)
	end 
	
	def initialize(name)
		@name = name
		@settings = UserSettings.new()
	end

end
