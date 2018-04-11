##
# File          :: Chapter.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 01/28/2018
# Last update   :: 01/28/2018
# Version       :: 0.1
#
# This class represents the application.
# A picross is composed of several chapters.
# A picross is composed of several users.

class Picross

	##
	# Create a picross, empty by default
	# * *Arguments* :
	#   - +users+ -> list of chapter(s) that are composing the game
	#   - +chapters+ -> list of user(s) that composing the game
	def initialize(users=nil, chapters=nil)

		# Set path variable to Users folder
		@path = File.expand_path(File.dirname(__FILE__) + '/' + '../Users')

		@users = retrieveUser
		@chapters = retrieveChapter
	end

	##
	# Retuns the picross to a string, for debug only
	# * *Returns* :
	#   - the picross into a String object
	def to_s()
		return "Users : #{@users}, chapters : #{@chapters}"
	end

	##
	# This function retrieve all user available
	def retrieveUser()
		return Dir.entries(@path).select { |f| f.match(/User\_(.*)/)}.select{|x| x.slice!(0,5)}
	end

	##
	# This function return the loaded user (Class User) from the selected user in comboBox
	def getSelectedUser(user)
		return User.load(@path + "/User_" + user)
	end

	def retrieveChapter()
		chapters = Array.new()

		# Retrieve all default chapters
		chapterFolder = File.expand_path(@path + '/' + "Default/chapters/")
		chapterFile = Dir.entries(chapterFolder).select { |f| f.match(/(.*).chp/)}

		chapterFile.sort! do |x, y|
			x.partition('_')[0] <=> y.partition('_')[0]
		end

		chapterFile.each do |f|
			chapters.push(Chapter.load(chapterFolder + "/"+ f))
		end
		return chapters
	end

	def sauvegarde(user,chapter, map)
		indexUser = @users.index(user)
		indexChapter = user.chapters.index(chapter)
		indexMap = chapter[indexChapter].levels.index(map)
		hypotheses = chapter[indexChapter].levels[indexMap].hypotheses
		hypotheses = map.hypotheses
		user.save()
		@users[indexUser] = user
	end

	def ajouteUser(name, lang)
		if(name != nil) then
			# Check if the user already exist?
			if(!retrieveUser.include? name )
				# Check if entry only contains letters, numbers and "_"
				if(name.match(/[a-zA-Z0-9_]*/) ) then
					user = User.new(name, @chapters)
					user.lang = lang
					user.save()
					return true, user
				end
			end
		end
		return false, nil
	end

	##
	# Convert the picross to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the picross converted to an array
	def marshal_dump()
		return [@users, @chapters]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a map object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the picross object itself
	def marshal_load(array)
		@users, @chapters = array
		return self
	end
end
