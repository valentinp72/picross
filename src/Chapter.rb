##
# File          :: Chapter.rb
# Author        :: BROCHERIEUX Thibault
# Licence       :: MIT License
# Creation date :: 01/28/2018
# Last update   :: 01/28/2018
# Version       :: 0.1
#
# This class represents a chapter.
# A chapter is composed of several map.

class Chapter

	##
	# Create a chapter, the chapter is locked by default
	# * *Arguments* :
	#   - +title+ -> the title of the chapter
	#   - +levels+ -> List of map that are part of this chapter
	#   - +isUnlocked+ -> Wether or not the chapter is unlocked
	#   - +starsRequired+ -> the number of stars required to unlock the chapter

	def initialize(title, levels, starsRequired, isUnlocked=false)
		@title = title
		@levels = levels
		@starsRequired = starsRequired
		@isUnlocked = isUnlocked
	end

	def playLevel(index)
		return @mapList[index]
	end

	##
	# Retuns the chapter to a string, for debug only
	# * *Returns* :
	#   - the chapter into a String object
	def to_s()
		return "Chapter : #{@title}, levels : #{@levels}, stars required : #{@starsRequired}, unlocked? : #{@isUnlocked}, "
	end

	##
	# Convert the chapter to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the chapter converted to an array
	def marshal_dump()
		return [@title, @levels, @starsRequired, @isUnlocked]
	end

	##
	# Update all the instances variables from the array given,
	# allowing Marshal to load a chapter object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the chapter object itself
	def marshal_load(array)
		@title, @levels, @starsRequired, @isUnlocked = array
		return self
	end
end
