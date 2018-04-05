require_relative 'Map'
require_relative 'EvolvingMap'

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

	# Exception when the chapter to load does not exists.
	class ChapterNotFoundException < StandardError; end
	# Exception when the chapter cannot be load by Marshal (not a marshal file?).
	class CorruptedChapterException < StandardError; end

	attr_reader :title
	
	attr_reader :levels
	
	attr_reader :starsRequired
	
	attr_reader :isUnlocked

	##
	# Create a chapter, the chapter is locked by default
	# * *Arguments* :
	#   - +title+ -> the title of the chapter
	#   - +levels+ -> List of map that are part of this chapter
	#   - +starsRequired+ -> the number of stars required to unlock the chapter
	def initialize(title, levels, starsRequired)
		@title = title
		@levels = levels
		@starsRequired = starsRequired
	end

	##
	# Returns true if the chapter is unlocked for the given user, false otherwise
	# * *Arguments* :
	#   - +user+ -> the user to check if the chapter is unlocked
	# * *Returns* :
	#   - true if the chapter is unlocked
	def unlocked?(user)
		return user.totalStars >= @starsRequired
	end

	def each_map
		@levels.each do |map|
			yield map
		end
	end

	##
	# Retuns the chapter to a string, for debug only
	# * *Returns* :
	#   - the chapter into a String object
	def to_s()
		return "Chapter : #{@title}, levels : #{@levels}, stars required : #{@starsRequired}" 
	end

	##
	# Load the file chapter to a new Chapter object.
	# * *Arguments* :
	#   - +fileName+ -> the chapter to load
	# * *Returns* :
	#   - the Chapter object corresponding to the object to load
	# * *Raises* :
	#   - +ChapterNotFoundException+  -> if the file does not exists
	#   - +CorruptedChapterException+ -> if the file is corrupted to Marshal (not a Marshal file?)
	def Chapter.load(fileName)
		raise ChapterNotFoundException unless File.exists?(fileName)
		begin
			return Marshal.load(File.read(fileName))
		rescue => exception
			puts exception
			puts exception.backtrace
			raise CorruptedChapterException
		end
	end

	##
	# Save the Chapter object to the given file name.
	# * *Arguments* :
	#   - +dir+ -> the output directory
	# * *Returns* :
	#   - the object itself
	def save(dir, name=@title)
		fileName = dir + name + ".chp"
		File.open(fileName, 'w') { |f| f.write(Marshal.dump(self)) }
		return self
	end

	##
	# Converts the chapter to an array, allowing Marshal to dump the object.
	# * *Returns* :
	#   - the chapter converted to an array
	def marshal_dump()
		return [@title, @levels, @starsRequired]
	end

	##
	# Updates all the instance variables from the given array,
	# allowing Marshal to load a chapter object.
	# * *Arguments* :
	#   - +array+ -> the array to transform to instances variables
	# * *Returns* :
	#   - the chapter object itself
	def marshal_load(array)
		@title, @levels, @starsRequired = array
		return self
	end

end
