# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 03/27/2018
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

		#Speaker
		@lines = [[2],[3],[2,1],[2,1],[3,1],[4,1,1],[1,1,1],[1,1,1],[1,1,1],[4,1,1],[3,1],[2,1],[2,1],[3],[2]]
		@clns = [[1,1],[1,1],[1,1],[7],[1,1],[9],[2,2],[2,2],[2,2],[15]]

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
		#@lines = [[1,1],[2,2],[1,6,1],[1,1],[1,1,1,1],[1,1,1],[1,1,1],[1,3,1],[1,1],[10]]
		#@clns = [[10],[1,1],[1,1],[1,1,1,1],[1,3,1],[1,1,1,1],[1,1],[1,1],[1,1],[10]]

		#Me
		#@lines = [[2,3,2],[1,4,4,1],[6,6],[15],[3,3,1,3],[3,1,1,5],[3,1,1,1,4],[3,3,1,5],[2,3,1,2],[1,11,1],[2,9,2],[3,7,3],[4,5,4],[5,3,5],[6,1,6]]
		#@clns = [[2,5,6],[1,7,5],[9,4],[3,2,3],[4,6,2],[5,6,1],[1,3,8],[1,1,6],[1,12],[3,4,1],[3,1,1,3,2],[3,3,2,3],[9,4],[1,7,5],[2,5,6]]

		#Panda (fonctionne pas)
		#@lines = [[3,10],[1,4,3,1],[1,2,3],[3,1,1,1],[2,2,2,1],[2,1,1,1,1,2],[1,3,3,1],[1,2,2,1],[2,2],[3,2,1],[4,1,2,1,3],[2,2,4,2,1],[2,2,2,1],[3,6,1],[4,3]]
		#@clns = [[4,6],[1,12],[6,3,2],[2,2,1],[1,3,2],[2,1,2,1,2],[1,4,1,1],[1,3,1],[1,3,1],[1,4,1,1],[2,1,2,1,2],[2,3,2],[3,2,1],[1,4,3,1],[3,4,5]]

		#Initialisation de la grille
		@grid = Array.new(@lines.size()) do |j|
			Array.new(@clns.size()) do |i|
				0
			end
		end
	end

	#Résolution de la grille
	def traitement()
		nbcasetot=0		#total de case à colorier sur la grille
		# Calcul total de case à colorier sur la grille (somme des indices de chaque lignes)
		for i in @lines	#pour chaque ligne
			for j in i	#pour chaque indice
				nbcasetot += j
			end
		end

		#Remplissage lignes et colonnes en partie coloriées
		while (self.nbcasecoloriee()!=nbcasetot)
			#On remplit les cases
			for i in 0...@clns.size()
				self.traiterrange(i,"column")
			end

			for i in 0...@lines.size()
				self.traiterrange(i,"line")
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
				if(@grid[i][j] == 1)	#case coloriée
					print "0"
				elsif @grid[i][j] == -1		#case cochée
					print " "
				else			#case indéterminée
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
	def cptColor(num, range)
		cpt = 0
		cpt2 = 0

		if range.eql?("column") then
			taille=@lines.size()
			tabTemp=@clns
		else
			taille=@clns.size()
			tabTemp=@lines
		end

		#Calcule nombre de cases dans la range
		for i in 0...taille
			if range.eql?("column") then
				if @grid[i][num] == 1
					cpt += 1
				end
			else
				if @grid[num][i] == 1
					cpt += 1
				end
			end
		end

		#Calcul de la somme des indices d'une range
		for i in 0...tabTemp[num].size()
			cpt2 += tabTemp[num][i]
		end

		if cpt == cpt2
			return true
		else
			return false
		end
	end

	#Coche toute les cases indéterminée d'une ligne
	def cocheCaseIndeter(num, range)

		if range.eql?("column") then
			taille = @lines.size()
		else
			taille = @clns.size()
		end

		#Parcours de la range et si case indéterminée on met une croix
		for i in 0...taille
			if range.eql?("column") then
				if @grid[i][num]==0 then
					@grid[i][num]=-1
				end
			else
				if (@grid[num][i]==0) then
					@grid[num][i]=-1
				end
			end
		end
	end

	#Coche les cases qui ne peuvent correspondre à aucun indice
	def cocheCaseImpossible(num, range)
		if range.eql?("column") then
			taille = @lines.size()
			tabTemp = @clns
		else
			taille = @clns.size()
			tabTemp = @lines
		end

		if(tabTemp[num].size() == 1)		#si un seul indice sur la range
			indice = tabTemp[num][0]

			#si une case est coloriée sur la range, on coche toutes les cases trop éloignées pour correspondre au bloc
			for j in 0...taille
				if range.eql?("column") then
					if(@grid[j][num]==1)
						fin = j-indice
						for i in 0..fin
							@grid[i][num]=-1
						end
						debut = j+indice
						for i in debut...taille
							@grid[i][num]=-1
						end
					end
				else
					if(@grid[num][j]==1)
						fin = j-indice
						for i in 0..fin
							@grid[num][i]=-1
						end
						debut = j+indice
						for i in debut...taille
							@grid[num][i]=-1
						end
					end
				end
			end
		end
	end


	#coche toute les cases qui sont sûres de ne pas être des cases coloriées
	def cochergrille()
		#Cocher toutes les cases indéterminées des lignes et colonnes possédant déja leurs cases coloriées
		for i in 0...@lines.size()
			if (self.cptColor(i, "line"))
				self.cocheCaseIndeter(i, "line")
			end
			self.cocheCaseImpossible(i, "line")
		end

		for i in 0...@clns.size()
			if (self.cptColor(i, "column"))
				self.cocheCaseIndeter(i, "column")
			end
			self.cocheCaseImpossible(i, "column")
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

	#Calcul et renvoi la première possibilité du placement des indices sur la range en paramètre
	def premierePossibilite(num, range)
		tab = []
		indice = 1
		j = 0

		if range.eql?("column") then
			taille = @lines.size()
			tabTemp = @clns
			tabTemp[num].each do |block|
				c = 1
				while c <= block
					if(@grid[j][num] == -1)		#si une croix bloque le positionnement du bloc d'indice, on le recommence a partir de la case suivant la croix
						tab.delete(indice)
						for p in 1..c
							tab.push(0)
						end
						c = 0
					else					#sinon on place une partie du bloc sur la case
						tab.push(indice)
					end
					j += 1
					c +=1
				end
				if (j<taille)then 		#espace si il y a de la place
					tab.push(0)
				end
				j += 1
				indice += 1
			end
		else
			taille = @clns.size()
			tabTemp = @lines
			tabTemp[num].each do |block|
				c = 1
				while c <= block
					if(@grid[num][j] == -1)
						tab.delete(indice)
						for p in 1..c
							tab.push(0)
						end
						c = 0
					else
						tab.push(indice)
					end
					j += 1
					c +=1
				end
				if (j<taille)then 		#espace si il y a de la place
					tab.push(0)
				end
				j += 1
				indice += 1
			end
		end

		#une fois les blocs d'indice posés, on remplit le reste du tableau de 0
		while(j < taille)
			tab.push(0)
			j+=1
		end

		return tab
	end


	#Calcul et renvoi la première possibilité du placement des indices en partant de la fin sur la range en paramètre
	def deuxiemePossibilite(num, range)
		tab = []

		if range.eql?("column") then
			taille = @lines.size()
			tabTemp = @clns
			reverse = tabTemp[num].reverse
			indice = tabTemp[num].size()
			j = taille - 1

			reverse.each do |block|
				c=1
				while(c<=block)
					if(@grid[j][num]==-1)   #cochée
						tab.delete(indice)
						for p in 1..c
							tab.unshift(0)
						end
						c=0
					else	#1 (colorier) ou 0 (indéterminée)
						tab.unshift(indice)
					end
					j-=1
					c+=1
				end
				if (j>=0)then 		#espace si il y a de la place
					tab.unshift(0)
				end
				j-=1
				indice-=1
			end
		else
			taille = @clns.size()
			tabTemp = @lines
			reverse = tabTemp[num].reverse
			indice = tabTemp[num].size()
			j = taille - 1

			reverse.each do |block|
				c=1
				while(c<=block)
					if(@grid[num][j]==-1)   #cochée
						tab.delete(indice)
						for p in 1..c
							tab.unshift(0)
						end
						c=0
					else	#1 (colorier) ou 0 (indéterminée)
						tab.unshift(indice)
					end
					j-=1
					c+=1
				end
				if (j>=0)then 		#espace si il y a de la place
					tab.unshift(0)
				end
				j-=1
				indice-=1
			end
		end

		while (j>=0)
			tab.unshift(0)
			j-=1
		end

		return tab
	end


	#Colorie les cases certaines d'une range
	def traiterrange(num, range)

		tab1 = premierePossibilite(num, range)
		tab2 = deuxiemePossibilite(num, range)

		if range.eql?("column") then
			taille = @lines.size();
		else
			taille = @clns.size();
		end

		#Coloriage des cases sûres (intersection des 2 possibilités)
		for i in 0...taille
			if (tab1[i]==tab2[i] && tab1[i]>0) then
				if range.eql?("column") then
					@grid[i][num]=1
				else
					@grid[num][i]=1
				end
			end
		end

		#Extrémités du plateau
		#De la gauche vers la droite
		j=0
		if range.eql?("column") then		#pour une colonne
			while((@grid[j][num]==-1) && (j<(taille-1)))
				j+=1
			end
			if (@grid[j][num]==1)
				fin = @clns[num][0]+j
				if (fin>taille-1)
					fin = taille-1
				end
				for i in (j+1)...fin
					@grid[i][num]=1
				end
			end
		else								#pour une ligne
			while((@grid[num][j]==-1) && (j<taille))
				j+=1
			end
			if (@grid[num][j]==1)
				fin = @lines[num][0]+j
				if (fin>taille-1)
					fin = taille-1
				end
				for i in (j+1)...fin
					@grid[num][i]=1
				end
			end
		end

		#De la droite vers la gauche
		j=taille-1;

		if range.eql?("column") then		#pour une colonne
			while((@grid[j][num]==-1) && (j>0))
				j-=1
			end
			if (@grid[j][num]==1)
				fin = j
				debut = (fin-@clns[num][@clns[num].size()-1])+1
				if(debut<0)
					debut = 0
				end
				for i in debut...fin
					@grid[i][num]=1
				end
				if (debut>0)
					@grid[debut-1][num]=-1
				end

			end
		else
			while((@grid[num][j]==-1) && (j>0))
				j-=1
			end
			if (@grid[num][j]==1)
				fin = j
				debut = (fin-@lines[num][@lines[num].size()-1])+1
				if(debut<0)
					debut = 0
				end
				for i in debut...fin
					@grid[num][i]=1
				end
				if(debut>0)
					@grid[num][debut-1]=-1
				end
			end
		end
	end
end


test = Resolver.new()
test.traitement()
