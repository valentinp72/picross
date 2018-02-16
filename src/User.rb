require_relative 'UserSettings'
require_relative 'Chapter'
require_relative 'Map'
require 'fileutils'

##
# File			:: User.rb
# Author		:: COHEN Mehdi, PASTOURET Gilles
# Licence		:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 02/12/2018
#
# This class represents a user's profile
# 
class User
	## Class variables
	# +userDirectoryPath+
	
	@@allUsersPath = './Users/'
	
	## Instance variables
	# +name+			- player's name
	# +settings+		- player's settings
	# +chapters+			- array of chapters own by the user
	# +userPath+
	# +availableHelps+	- amount of help that the player can spend

	attr_accessor :name
	attr_reader :settings
	
	private_class_method :new

	##
	# Creates a new User object
	# * *Arguments* :
	#   - +name+ -> a String representing the user's name
	def User.create(name)
		new(name,'create')
	end 
	
	##
	# Loads a new User object
	# * *Arguments* :
	#   - +name+ -> a String representing the user's name
	def User.load(name)
		new(name,'load')
	end 
	
	##
	# Initialises a user by creation or loading
	# * *Arguments* :
	#   - +name+ -> Name of the user
	#   - +mode+ -> 'load' to load from a serialized object 
	#				or 'create' to create a new one
	def initialize(name,mode)
		@name = name
		@userPath = @@allUsersPath+'User_'+name+'/'
		@settings = UserSettings.new()
		
		if mode=='create'
			@name = name
			@chapters = [Chapter.new('Chapter_test1', [], 99),
						Chapter.new('Chapter_test2', [], 99)] ##loads default chapters
			@availableHelps = 0
			
		elsif mode=='load'
			if(Dir.exists?(@userPath))
				configFile = File.open(@userPath+'config','r')
				
				binaryConfig = ''
				while !configFile.eof?
					binaryConfig += configFile.gets
				end
				
				self.marshal_load(Marshal.load(binaryConfig))
				configFile.close
			end
		end
	end
	
	##
	# Prepare the object for a Marshal dump by converting the chapter 
	# into an array.
	# * *Returns* :
	#   - the user and its components converted into an array
	def marshal_dump ()
		dumpedSettings = @settings.marshal_dump()
		[@name,dumpedSettings,@availableHelps]
	end
	
	##
	# Updates all the instance variables from the given array
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - this object
	def marshal_load (array)
		@name,dumpedSettings,@availableHelps = array
		@settings.marshal_load(dumpedSettings)
		return self
	end
	
	##
	# Saves a user and his associated chapters
	def save ()
		## Create the user's directory if it doesn't exist
		if(!Dir.exists?(@userPath))
			FileUtils::mkdir_p(@userPath)
		end
		## Saving the dumped User+UserSettings into config
		configFile = File.new(@userPath+'config','w')
		dataConfig = self.marshal_dump()
		
		configFile.write(Marshal.dump(dataConfig))
		configFile.close
		
		## Saving chapters
		chaptersPath = @userPath+'Chapters'
		if(!Dir.exists?(chaptersPath))
			FileUtils::mkdir_p(chaptersPath)
		end
		@chapters.each do |chap|
			chap.save(@userPath+'Chapters/')
		end
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
	# Returns a String representing the user
	def to_s
		return "User : name=#{@name} availableHelps=#{@availableHelps}"
	end
end


###Test
user1 = User.create('Mehdi')
print "#####Avant recharge : \n"
print user1.to_s+' '+user1.settings.to_s
user1.save()

user2 = User.load('Mehdi')
puts "\n#####Après recharge : \n"
print user2.to_s+' '+user2.settings.to_s

