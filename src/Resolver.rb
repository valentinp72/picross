
class Resolver

	@lines	#int[]
	@clns #int[]
	@grid #int[][]	#0 : case indéterminée, -1 : case cochée, 1 : case coloriée
	

	
	#Constructeur
	def initialize()

		#@lines = [[5],[3],[1],[3],[5]]
		#@clns = [[1,1],[2,2],[5],[2,2],[1,1]]
		
		@lines = [[3],[1],[3],[2,1],[1,2]]
		@clns = [[1],[3],[1,2],[2,1],[1,2]]

		@grid = Array.new(@lines.size()) do |j|
			Array.new(@clns.size()) do |i| 
				0
			end
		end	
	end

	#Résolution de la grille
	def traitement()

		tcln = @clns.size()
		tline = @lines.size()
		somme=0
		nbcasetot=0		#total de case à colorier sur la grille
		tabResLin = []
		tabResCol = []
		
		for i in @lines	#pour chaque ligne
			for j in i	#pour chaque indice
				
				somme=somme+j		#somme des indices
				nbcasetot += j		# calcul total de case à colorier sur la grille
			end

			tabResLin.push(tline-(somme+(i.size()-1)))
			somme=0
		end	
		
		for i in @clns	#pour chaque colonne
			for j in i	#pour chaque indice
				
				somme=somme+j		#somme des indices
			end

			tabResCol.push(tcln-(somme+(i.size()-1)))
			somme=0
		end
		
		#Remplissage des lignes pleines
		for i in 0...tline
			j=0
			
			@lines[i].each do |block|
			
				for c in 1..block
					
					if(c>tabResLin[i])
						@grid[i][j]=1
					end
					j+=1
				end
				j+=1
				
			end	
			
		end

		#Remplissage des colonnes pleines
		for i in 0...tcln
			j=0
			@clns[i].each do |block|
				for c in 1..block
					if(c>tabResCol[i])
						@grid[j][i]=1
					end
					j+=1
				end
				j+=1
	
			end	
			
		end
		
		#Remplissage lignes et colonnes en partie coloriées
		while (self.nbcasecoloriee()!=nbcasetot)
		
			puts(self.nbcasecoloriee())
			puts(nbcasetot)
		
			#On coche les cases impossibles (on les met à -1)
		
		
		
			#On remplit les cases 
		
		
		
		end
	end

	
	
	#Affiche la grille résolue
	def afficher()

		i=0

		while(i<@lines.size())
			
			j=0
			while(j<@clns.size())
			
			
				print (@grid[i][j]==1 ? "O": "-")
				print " "
				j = j+1
			end
			i = i+1
			puts""
		end
	end
	
	#Calcul le nombre de case coloriées sur la grille
	def nbcasecoloriee()
	
		nb=0
		i=0
	
		while(i<@lines.size())
			
			j=0
			while(j<@clns.size())
			
				if(@grid[i][j]==1) then 
					nb += 1
				end
				j += 1
			end
			i = i+1
		end
		return nb
	end

end

test = Resolver.new()
test.traitement()
test.afficher()
