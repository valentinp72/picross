# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 03/08/2018
#


class Resolver


	#Variables d'instance
	@lines	#int[]
	@clns #int[]
	@grid #int[][]	#0 : case indéterminée, -1 : case cochée, 1 : case coloriée

	
	#Constructeur
	def initialize()

		#Sablier
		#@lines = [[5],[3],[1],[3],[5]]
		#@clns = [[1,1],[2,2],[5],[2,2],[1,1]]

		#Grille 5x5 de la feuille
		#@lines = [[3],[1],[3],[2,1],[1,2]]
		#@clns = [[1],[3],[1,2],[2,1],[1,2]]
		
		#Grille 10x5 de la feuille
		#@lines = [[1,2],[3],[4],[3],[5],[4],[2],[5],[4],[1]]
		#@clns = [[1,2,1],[8],[8],[3,2,2],[1,1,2,3]]
		
		#Speaker (fonctionne pas)
		#@lines = [[2],[3],[2,1],[2,1],[3,1],[4,1,1],[1,1,1],[1,1,1],[1,1,1],[4,1,1],[3,1],[2,1],[2,1],[3],[2]]
		#@clns = [[1,1],[1,1],[1,1],[7],[1,1],[9],[2,2],[2,2],[2,2],[15]]

		#Tasse
		#@lines = [[1,1],[1,3],[10,1],[1,1,1],[1,3],[1,1],[10],[14]]
		#@clns = [[1],[1],[8],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[1,2],[8],[1,1,1],[4,1]]
		
		#TV
		#@lines = [[1,1],[0],[1,5,2],[1,1],[1,3,2,1],[1,1,1,1],[1,1,1,1],[1,4,1,1],[1,1],[1,6,1]]
		#@clns = [[1,8],[0],[1,4,1],[1,1,1,1],[1,1,1,1],[1,1,1],[1,1,1],[4,1],[1],[1,8]]
		
		#oiseau
		#@lines = [[3],[3],[5],[5,1],[7],[9],[9],[8],[6],[3],[1,1],[6],[3]]
		#@clns = [[4],[4],[8],[6,2],[10],[6,2],[6,1],[8,1],[7],[3],[2]]
		
		#Chat
		@lines = [[1,1],[2,2],[1,6,1],[1,1],[1,1,1,1],[1,1,1],[1,1,1],[1,3,1],[1,1],[10]]
		@clns = [[10],[1,1],[1,1],[1,1,1,1],[1,3,1],[1,1,1,1],[1,1],[1,1],[1,1],[10]]

		
		
		@grid = Array.new(@lines.size()) do |j|
			Array.new(@clns.size()) do |i|
				0
			end
		end
	end

	
	#Résolution de la grille
	def traitement()
		
		nbcasetot=0		#total de case à colorier sur la grille
		

		for i in @lines	#pour chaque ligne
			for j in i	#pour chaque indice

				nbcasetot += j		# calcul total de case à colorier sur la grille
			end
		end

		#Remplissage lignes et colonnes en partie coloriées
		while (self.nbcasecoloriee()!=nbcasetot)
   
			#On remplit les cases
			for i in 0...@clns.size()
	
				self.traitercolonne(i)
			end
			
			for i in 0...@lines.size()
			
				self.traiterligne(i)
			end
			
			self.afficher()
			sleep(2)
			
			#On coche les cases impossibles (on les met à -1)
			self.cochergrille()
		 	
			self.afficher()
			sleep(2)
		end
	end



	#Affiche la grille résolue
	def afficher()

		i=0

		while(i<@lines.size())

			j=0
			while(j<@clns.size())

        if(@grid[i][j] == 1)
          print "0"
        elsif @grid[i][j] == -1
          print " "
        else
          print "-"
        end
				print " "
				j = j+1
			end
			i = i+1
			puts""
		end
		puts("\n")
	end

	#Renvoit vrai si le nombre de case coloriée sur une colonne est égal à celui attendu
	def cptColorCol(numc)
    cpt = 0
    cpt2 = 0
    for i in 0...@lines.size()
        if @grid[i][numc] == 1
          cpt += 1
        end
    end
    for i in 0...@clns[numc].size()
      cpt2 += @clns[numc][i]
    end
    if cpt == cpt2
      return true
    else
      return false
    end

  end

	#Renvoit vrai si le nombre de case coloriée sur une ligne est égal à celui attendu
	def cptColorLine(numl)
    cpt = 0
    cpt2 = 0
    for i in 0...@clns.size()
        if @grid[numl][i] == 1
          cpt += 1
        end
    end

    for i in 0...@lines[numl].size()
      cpt2 += @lines[numl][i]
    end
    if cpt == cpt2
      return true
    else
      return false
    end
  end

	#Coche toute les cases indéterminée d'une ligne
	def cocheligne(numl)

		for i in 0...@clns.size()

			if (@grid[numl][i]==0) then
				@grid[numl][i]=-1
			end
		end
	end

	#Coche toute les cases indéterminées d'une colonne
	def cochecol(numc)

		for i in 0...@lines.size()

			if @grid[i][numc]==0 then
				@grid[i][numc]=-1
			end
		end
	end

	#Cocher les cases impossible d'une ligne
	def cocheSurline(numl)
	
		if(@lines[numl].size()==1)		#si un seul indice sur la ligne
			
			indice = @lines[numl][0]
		
			for j in 0...@clns.size()
				
				if(@grid[numl][j]==1)   #coloriée
					
					fin = j-indice
					for i in 0..fin
						
						@grid[numl][i]=-1
					end
						
					debut = j+indice
					for i in debut...@clns.size()
						
						@grid[numl][i]=-1
					end
				end
		
		
			end
		end
	end
	
	
	#Cocher les cases impossible d'une colonne
	def cocheSurcol(numc)
		
		if(@clns[numc].size()==1)		#si un seul indice sur la ligne
			
			indice = @clns[numc][0]
		
			for j in 0...@lines.size()
				
				if(@grid[j][numc]==1)   #coloriée
					
					fin = j-indice
					for i in 0..fin
						
						@grid[i][numc]=-1
					end
						
					debut = j+indice
					for i in debut...@lines.size()
						
						@grid[i][numc]=-1
					end
				end
		
		
			end
		end
	end

	
	#coche toute les cases qui sont sûres de ne pas être des cases coloriées
	def cochergrille()
	
		#Cocher toutes les cases indéterminées des lignes et colonnes possédant déja leurs cases coloriées
		for i in 0...@lines.size()
			if (self.cptColorLine(i))
				self.cocheligne(i)
			end
			
			#Cocher les cases impossible
			self.cocheSurline(i)
		end

		for i in 0...@clns.size()
			if (self.cptColorCol(i))
				self.cochecol(i)
			end
			
			#Cocher les cases impossible
			self.cocheSurcol(i)
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

	#Traite une ligne entiere
	def traiterligne(numl)

		tab1 = []
		tab2 = []

		indice=1		#numéro de l indice sur la ligne
		j=0				#compteur qui parcourt la ligne

		# Première possibilité en partant du début
		@lines[numl].each do |block|
			
			c=1
			while(c<=block)

				if(@grid[numl][j]==-1)   #cochée
				
					tab1.delete(indice)
					for p in 1..c
						
						tab1.push(0)		
						
					end
					c=0
				
				else	#1 (colorier) ou 0 (indéterminée)
				
					tab1.push(indice)
				end
				j+=1
				c+=1
			end
		
			if (j<@clns.size())then 		#espace si il y a de la place
				tab1.push(0) 
			end
			
			j+=1
			indice+=1

		end
		
		#on remplit le reste tant qu il reste de la place
		while (j<@clns.size())

			tab1.push(0)
			j+=1
		end
		
		
		# Deuxième possibilité en partant de la fin
		lineReverse = @lines[numl].reverse
		indice-=1
		j=@clns.size()-1
		
		lineReverse.each do |block|
			
			c=1
			while(c<=block)

				if(@grid[numl][j]==-1)   #cochée
				
					tab2.delete(indice)
					for p in 1..c
						
						tab2.unshift(0)	
						
					end
					c=0
				
				else	#1 (colorier) ou 0 (indéterminée)
				
					tab2.unshift(indice)
				end
				j-=1
				c+=1
			end
		
			if (j>=0)then 		#espace si il y a de la place
				tab2.unshift(0) 
			end
			
			j-=1
			indice-=1

		end
	
		#on remplit le reste
		while (j>=0)

			tab2.unshift(0)
			j-=1
		end
		
		#Coloriage des cases sûres
		for i in 0...@clns.size()
			
			if (tab1[i]==tab2[i] && tab1[i]>0) then
				@grid[numl][i]=1
			end
		end
		
		#Extrémités du plateau
		if (@grid[numl][0]==1)
			for i in 1...@lines[numl][0]
				@grid[numl][i]=1
			end
		end
		
		if (@grid[numl][@clns.size()-1]==1)
			fin = @clns.size()-1
			debut = (fin-@lines[numl][@lines[numl].size()-1])+1
			
			for i in debut...fin
				@grid[numl][i]=1
			end
		end

	end

	#Traite une colonne entiere
	def traitercolonne(numc)

		tab1 = []
		tab2 = []

		indice=1		#numéro de l indice sur la colonne
		j=0				#compteur qui parcourt la colonne

		# Première possibilité en partant du début
		@clns[numc].each do |block|
			
			c=1
			while(c<=block)

				if(@grid[j][numc]==-1)   #cochée
				
					tab1.delete(indice)
					for p in 1..c
						
						tab1.push(0)		
						
					end
					c=0
				
				else	#1 (colorier) ou 0 (indéterminée)
				
					tab1.push(indice)
				end

				
				j+=1
				c+=1
			end
		
			if (j<@lines.size())then 		#espace si il y a de la place
				tab1.push(0) 
			end
			
			j+=1
			indice+=1

		end
		
		#on remplit le reste tant qu il reste de la place
		while (j<@lines.size())

			tab1.push(0)
			j+=1
		end
		
		
		# Deuxième possibilité en partant de la fin
		colReverse = @clns[numc].reverse
		indice-=1
		j=@lines.size()-1
		
		colReverse.each do |block|
			
			c=1
			while(c<=block)

				if(@grid[j][numc]==-1)   #cochée
				
					tab2.delete(indice)
					for p in 1..c
						
						tab2.unshift(0)		
						
					end
					c=0
				
				else	#1 (colorier) ou 0 (indéterminée)
				
					tab2.unshift(indice)
				end
				j-=1
				c+=1
			end
		
			if (j>=0)then 		#espace si il y a de la place
				tab2.unshift(0) 
			end
			
			j-=1
			indice-=1

		end
		
		#on remplit le reste
		while (j>=0)

			tab2.unshift(0)
			j-=1
		end
		
		#Coloriage des cases sûres
		for i in 0...@lines.size()
			
			if (tab1[i]==tab2[i] && tab1[i]>0) then
				@grid[i][numc]=1
			end
			
		end
		
		#Extrémités du plateau
		if (@grid[0][numc]==1)
			for i in 1...@clns[numc][0]
				@grid[i][numc]=1
			end
		end
		
		if (@grid[@lines.size()-1][numc]==1)
			fin = @lines.size()-1
			debut = (fin-@clns[numc][@clns[numc].size()-1])+1
			for i in debut...fin
				@grid[i][numc]=1
			end
		end
	end
end


test = Resolver.new()
test.traitement()


