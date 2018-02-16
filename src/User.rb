require_relative 'UserSettings'
require_relative 'Chapter'
require 'fileutils'

##
# File			:: User.rb
# Author		:: COHEN Mehdi & PASTOURET Gilles
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
	#   - +name+		-> a String representing the user's name
	def User.create(name)
		new(name,'create')
	end 
	
	def User.load(name)
		new(name,'load')
	end 
	
	def initialize(name,mode)
		@name = name
		@userPath = @@allUsersPath+'User_'+name+'/'
		@settings = UserSettings.new()
		
		if mode=='create'
			@name = name
			#@chapters = Chapter.default ##loads default chapters
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
	# Saves a user and his associated chapters
	def save ()
		## Create the user's directory if it doesn't exist
		if(!Dir.exists?(@userPath))
			FileUtils::mkdir_p(@userPath)
		end
		## Saving marshalled User and UserSettings
		configFile = File.new(@userPath+'config','w')
		dataConfig = self.marshal_dump()
		
		puts Marshal.dump(dataConfig).to_s.inspect ###
		
		configFile.write(Marshal.dump(dataConfig))
		configFile.close
		
		## Saving chapters
		#@chapters.each do |chap|
		#	chap.save(@userPath+'Chapters/')
		#end
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
	
	def to_s
		print "User_"+@name+": "
		print "availableHelps="+@availableHelps.to_s+"\n"
		print "Settings :"
		print @settings.to_s
	end
end


###Test
user1 = User.create('Mehdi')
print "#####Avant recharge : \n"
print user1.to_s

user2 = User.load('Mehdi')
puts "\n#####Après recharge : \n"
print user2.to_s

