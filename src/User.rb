require_relative 'UserSettings'
require_relative 'Chapter'

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
	attr_reader :settings, :availableHelps, :chapters

	##
	# Creates a new User object
	# * *Arguments* :
	#   - +name+		-> a String representing the user's name
	def initialize(name, chapters)
		@name = name
		@settings = UserSettings.new()
		@availableHelps = 0
		@chapters = chapters

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

	def save()
		#print(Dir.pwd)
		path = File.expand_path(File.dirname(__FILE__) + '/' + "../Users/User_#{@name}")
		File.open(path, 'w'){|f| f.write(Marshal.dump(self))}
		return self
	end

	def User.load(filename)
		return Marshal.load(File.read(filename))
	end
	##
	#
	def marshal_dump()
		[@name,@settings,@availableHelps,@chapters]
	end

	##
	#
	def marshal_load(array)
		@name,@settings,@availableHelps,@chapters = array
		return self
	end
end
