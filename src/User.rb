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

	# +name+			- player's name
	# +settings+		- player's settings
	# +availableHelps+	- amount of help that the player can spend

	attr_accessor :name
	attr_reader :settings
	
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
		@availableHelps = 0
	end
	
	##
	# Adds an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+		-> a Fixnum representing an amount of help
	def addHelp (amount)
		unless (amount < 0)
			@availableHelps += amount
		else
			raise NegativeAmountException
		end
	end
	
	##
	# removes an amount of helps to the available help count
	# * *Arguments* :
	#   - +amount+		-> a Fixnum representing an amount of help
	def removeHelp (amount)
		unless (amount < 0)
			@availableHelps += amount
		else
			raise NegativeAmountException
		end
	end
	
	##
	#
	def marshal_dump ()
		dumpedSettings = @settings.marshal_dump()
		[@name,dumpedSettings,@availableHelps]
	end
	##
	#
	def marshal_load (array)
		@name,dumpedSettings,@availableHelps = array
		@settings.marshal_load(dumpedSettings)
		return self
	end
	
	##Je crois que j'ai fais NIMP sur le marshal mais j'y reviens plus tard
end
