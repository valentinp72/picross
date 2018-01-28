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
    @Users = users
    @chapters = chapters
  end

  ##
	# Retuns the picross to a string, for debug only
	# * *Returns* :
	#   - the picross into a String object
	def to_s()
		return "Users : #{@users}, chapters : #{@chapters}"
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
