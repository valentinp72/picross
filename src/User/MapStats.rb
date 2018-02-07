##
# implémentation minimaliste de la classe-association Statistics*
#

class Profil
	
	@maps
	@stats
	
	def initialize
		@stats = Hash.new 
		@maps = Array.new
	end
	def addMap (map)
		@stats[map] = Statistics.new(map,self)
		@maps.push(map)
	end
end

class Map

	@profils
	@stats
	
	def initialize
		@stats = Hash.new
		@profils = Array.new
	end
	
	def addProfil (profil)
		@stats[profil] = Statistics.new(self,profil)
		@profils.push(profil)
	end
end

class Statistics

	@map
	@profil
	
	attr_accessor :starsEarned :timePlayed :isFinished
	
	@starsEarned
	@timePlayed
	@isFinished
	
	def initialize(m,p)
		@map, @profil = m, p
	end
	
end