##
# File          :: Chapter.rb
# Author        :: Thibault Brocherieux
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
	#   - +starsRequired+ -> the number of stars required to unlock the chapter
  #   - +isUnlocked+ -> Wether or not the chapter is unlocked
  #   - +mapList+ -> List of map that are part of this chapter
  def initialize(title, starsRequired, isUnlocked=false, mapList)
    @title = title
    @starsRequired = starsRequired
    @isUnlocked = isUnlocked
    @mapList = mapList
  end

  def playLevel(index)
    return @mapList[index]
  end

  ##
  # Retuns the chapter to a string, for debug only
  # * *Returns* :
  #   - the chapter into a String object
  def to_s()
    return "Chapter : #{@title}, stars required : #{@starsRequired}, unlocked? : #{@isUnlocked}, mapList : #{@mapList}"
  end

  ##
  # Convert the chapter to an array, allowing Marshal to dump the object.
  # * *Returns* :
  #   - the chapter converted to an array
  def marshal_dump()
    return [@title, @starsRequired, @isUnlocked, @mapList]
  end

  ##
  # Update all the instances variables from the array given,
  # allowing Marshal to load a chapter object.
  # * *Arguments* :
  #   - +array+ -> the array to transform to instances variables
  # * *Returns* :
  #   - the chapter object itself
  def marshal_load(array)
    @title, @starsRequired, @isUnlocked, @mapList = array
    return self
  end
end
