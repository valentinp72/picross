require_relative 'Cell'
require_relative 'Grid'
require_relative 'Map'

##
# File          :: Grid.rb
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 04/04/2018
# Version       :: 0.1
#
# Represent a helper forthe user to resolve a picross

class Helper

	# Variables d'instance
	# @lines		int[]
	# @clns 		int[]
	# @grid 		int[][]	0 : case indéterminée, -1 : case cochée, 1 : case coloriée
	# @solution 	grille contenant la solution finale du picross

	# Constructeur
	def initialize(sol, line, col)

		@solution = sol
		# @solution = maj_solution(map.solution)			# si map en parametre au lieu de sol
		@lines = line
		@clns = col

		# Initialisation de la grille
		@grid = Array.new(@lines.size()) do
			Array.new(@clns.size()) do
				0
			end
		end
	end

	# renvoie un tableau [[x1,y1,etat1],[x2,y2,etat2],...] indiquant les cases
	# à colorier/cocher
	# x abscysse, y ordonnée, etat :  1=indéterminée / 2=coloriée / 3=cochée
	def traitement(userGrid, helpLvl)

		# Aide simple : Renvoit une ligne aléatoire non finie par l'utilisateur
		if helpLvl==1

			# Recherche une ligne aléatoire non complétée par l'utilisateur
			line = search_line(userGrid)
			help = []
			(0...@clns.size()).each do |i|
				help.push([line, i, convert_state(@solution[line][i])])
			end
			return help

		else

			# On place la grille de l'utilisateur dans la grille du solveur
			(0...@lines.size()).each do |i|
				(0...@clns.size()).each do |j|

					@grid[i][j] = userGrid[i][j]
				end
			end

			#self.solve()

			if helpLvl==2		# Aide moyenne

				return self.help2(userGrid)
			else # Aide difficile

				return self.help3(userGrid)
			end
		end
	end

	# Aide moyenne : Renvoit un groupe de cases que l'utilisateur
	# aurait pu trouver facilement
	def help2(userGrid)

		nbtour=0		# pour eviter boucle infinie si resultat introuvable
		while nbtour<10
			tabrange = []
			tabrange.push(rfull("line"))
			tabrange.push(rfull("column"))

			(tabrange[0]).each do |numl|
				bloc = bloc_not_complete(numl, "line", userGrid, "grid")
				return bloc unless bloc.empty?()
			end

			(tabrange[1]).each do |numc|

				bloc2 = bloc_not_complete(numc, "column", userGrid, "grid")
				return bloc2 unless bloc2.empty?()
			end

			self.solve()
			nbtour+=1
		end

		# si introuvable, on donne un bloc aléatoire de la solution que
		# l'utilisateur n'a pas trouver
		puts("ALEATOIRE")

		(0...@lines.size()).each do |numl|

			bloc = bloc_not_complete(numl, "line", userGrid, "solution")
			return bloc unless bloc.empty?()
		end

		(0...@clns.size()).each do |numc|
			bloc2 = bloc_not_complete(numc, "column", userGrid, "solution")
			return bloc2 unless bloc2.empty?()
		end
	end

	# Aide difficile : Renvoit une case que l'utilisateur aurait pu
	# trouver facilement
	def help3(userGrid)

		i=0
		while i<@lines.size()
			j=0
			while j<@clns.size()

				if @grid[i][j]==1 && (userGrid[i][j]).zero?

					return([[i, j, Cell::CELL_BLACK]])
				end
				j+=1
			end
			i+=1
		end

		# si introuvable, on donne une case aléatoire de la solution que
		# l'utilisateur n'a pas trouver
		puts("ALEATOIRE :")
		(0...@clns.size()).each do |i|
			(0...@lines.size()).each do |j|

				if @solution[i][j]==1 && (userGrid[i][j]).zero?
					return([[i, j, Cell::CELL_BLACK]])
				end
			end
		end
		# si toutes les cases sont déja bien coloriées,
		# l'aide ne donne aucune solutions
		return([])
	end

	# Convertit la grille de cellules finales en grille de solution d'entier
	def maj_solution(cellGrid)
		soluce = Array.new(5) do
			Array.new(5) do
				-1
			end
		end
		(0...@lines.size()).each do |i|
			(0...@clns.size()).each do |j|
				soluce[i][j]=1 if cellGrid.cellPosition(i, j).state==CELL_BLACK
			end
		end
		return soluce
	end

	# Convertit un entier représenté sur la grille par 0,-1 ou 1 en un état
	def convert_state(entier)

		if entier==1
			return Cell::CELL_BLACK
		elsif entier.zero?
			return Cell::CELL_WHITE
		else
			return Cell::CELL_CROSSED
		end

	end

	# Retourne la valeur d'une grille (@grid ou @solution) en fonction de la range
	# en paramètre (ligne ou colonne)
	def get_grid(mat, numl, numc, range)

		grid = if mat.equal?("grid")
			@grid
		else
			@solution
		end

		if range.eql?("column")
			return grid[numc][numl]
		else
			return grid[numl][numc]
		end
	end

	# Modifie la valeur de la grille en fonction de la range en paramètre
	# (ligne ou colonne)
	def set_grid(numl, numc, value, range)

		if range.eql?("column")
			@grid[numc][numl]=value
		else
			@grid[numl][numc]=value
		end
	end

	# Renvoit un tableau des numéros de lignes et colonnes pleines de la grille
	def rfull(range)

		tab = []
		if range.eql?("column")
			taille=@lines.size()
			taille2=@clns.size()
		else
			taille=@clns.size()
			taille2=@lines.size()
		end

		# regarde si range pleine
		(0...taille2).each do |num|
			j=0
			while j<taille
				if get_grid("grid", num,j,range).zero?
					j=taille
				elsif j==taille-1		# si range pleine on push
					tab.push(num)
				end
				j+=1
			end
		end
		return tab
	end

	# renvoit le premier bloc non complet de la grille de l'utilisateur,
	# tableau vide sinon
	def bloc_not_complete(num, range, userGrid, matrix)

		bloc=false
		tab=[]

		taille = if range.eql?("column")
			@lines.size()
		else
			@clns.size()
		end

		(0...taille).each do |i|

			if get_grid(matrix, num, i, range)==1

				if range.eql?("column")
					tab.push([i, num, Cell::CELL_BLACK])
					bloc=true if (userGrid[i][num]).zero?
				else
					tab.push([num, i, Cell::CELL_BLACK])
					bloc=true if (userGrid[num][i]).zero?
				end
			elsif bloc==false
				tab.clear()
			elsif bloc==true
				return tab
			end
		end

		tab.clear() if bloc==false
		return tab
	end

	# Recherche une ligne aléatoire non complétée par l'utilisateur
	def search_line(userGrid)

		i=0
		tabl=[]

		# Met dans un tableau les numéros des lignes non complétées
		while i<@lines.size()

			j=0
			while j<@clns.size()

				tabl.push(i) if (userGrid[i][j]).zero?
				j+=1
			end
			i+=1
		end

		# Choisit aléatoirement un numéro de ligne dans le tableau
		# (plus de chance d'avoir une des lignes les moins remplies)
		return tabl[Random.rand(tabl.size())]

	end

	# utilise les méthodes de résolution pour continuer la grille
	def solve

		self.afficher()
		# On coche les cases impossibles (on les met à -1)
		self.cochergrille()

		# On remplit les cases
		(0...@clns.size()).each do |i|
			self.traiterrange(i, "column")
		end

		(0...@lines.size()).each do |i|
			self.traiterrange(i, "line")
		end
	end

	# Affiche la grille résolue
	def afficher()
		i=0
		while i<@lines.size()
			j=0
			while j<@clns.size()
				if @grid[i][j] == 1   # case coloriée
					print "0"
				elsif @grid[i][j] == -1   # case cochée
					print " "
				else   # case indéterminée
					print "-"
				end
				print " "
				j += 1
			end
			i += 1
			puts ""
		end
		puts("\n")
	end

	# Renvoit vrai si le nombre de case coloriée sur une range
	# est égal à celui attendu
	def cpt_color(num, range)
		cpt = 0
		cpt2 = 0

		if range.eql?("column")
			taille=@lines.size()
			tabTemp=@clns
		else
			taille=@clns.size()
			tabTemp=@lines
		end

		# Calcule nombre de cases dans la range
		(0...taille).each do |i|
			if range.eql?("column")

				cpt += 1 if @grid[i][num] == 1

			elsif @grid[num][i] == 1
				cpt += 1
			end
		end

		# Calcul de la somme des indices d'une range
		(0...tabTemp[num].size()).each do |i|
			cpt2 += tabTemp[num][i]
		end

		if cpt == cpt2
			return true
		else
			return false
		end
	end

	# Coche toute les cases indéterminées d'une ligne
	def coche_case_indeter(num, range)

		taille = range.eql?("column") ? @lines.size() : @clns.size()

		# Parcours de la range et si case indéterminée on met une croix
		(0...taille).each do |i|
			if range.eql?("column")

				@grid[i][num]=-1 if (@grid[i][num]).zero?
			elsif (@grid[num][i]).zero?
				@grid[num][i]=-1
			end
		end
	end

	# Coche les cases qui ne peuvent correspondre à aucun indice
	def coche_case_impossible(num, range)

		if range.eql?("column")
			taille = @lines.size()
			tabTemp = @clns
		else
			taille = @clns.size()
			tabTemp = @lines
		end

		if tabTemp[num].size() == 1		# si un seul indice sur la range
			indice = tabTemp[num][0]

			# si une case est coloriée sur la range, on coche toutes les cases
			# trop éloignées pour correspondre au bloc
			(0...taille).each do |j|
				if get_grid("grid", num, j, range)==1

					fin = j-indice
					(0..fin).each do |i|
						set_grid(num, i, -1, range)
					end
					debut = j+indice
					(debut...taille).each do |i|
						set_grid(num, i, -1, range)
					end
				end
			end
		end
	end

	# Cocher toutes les cases indéterminées des lignes et colonnes
	# possédant déja leurs cases coloriées
	def cochergrille()

		(0...@lines.size()).each do |i|

			self.coche_case_indeter(i, "line") if self.cpt_color(i, "line")
			self.coche_case_impossible(i, "line")
		end

		(0...@clns.size()).each do |i|

			self.coche_case_indeter(i, "column") if self.cpt_color(i, "column")
			self.coche_case_impossible(i, "column")
		end
	end

	# Calcul et renvoi la première possibilité du placement des indices
	# sur la range en paramètre
	def premiere_possibilite(num, range)

		tab = []
		indice = 1
		j = 0
		if range.eql?("column")
			taille=@lines.size()
			tabTemp=@clns
		else
			taille=@clns.size()
			tabTemp=@lines
		end

		tabTemp[num].each do |block|
			c = 1
			while c <= block
				# si une croix bloque le positionnement du bloc d'indice,
				# on le recommence a partir de la case suivant la croix
				if get_grid("grid", num, j, range)== -1
					tab.delete(indice)
					(1..c).each do
						tab.push(0)
					end
					c = 0
				else   # sinon on place une partie du bloc sur la case
					tab.push(indice)
				end
				j += 1
				c +=1
			end
			# espace si il y a de la place
			tab.push(0) if j<taille

			j += 1
			indice += 1
		end

		# une fois les blocs d'indice posés, on remplit le reste du tableau de 0
		while j < taille
			tab.push(0)
			j+=1
		end

		return tab
	end

	# Calcul et renvoi la première possibilité du placement des indices
	# en partant de la fin sur la range en paramètre
	def deuxieme_possibilite(num, range)
		if range.eql?("column")
			taille=@lines.size()
			tabTemp=@clns
		else
			taille=@clns.size()
			tabTemp=@lines
		end

		tab = []
		reverse = tabTemp[num].reverse
		indice = tabTemp[num].size()
		j = taille - 1

		reverse.each do |block|
			c=1
			while c<=block
				if get_grid("grid", num, j, range)== -1  # cochée
					tab.delete(indice)
					(1..c).each do
						tab.unshift(0)
					end
					c=0
				else  # 1 (colorier) ou 0 (indéterminée)
					tab.unshift(indice)
				end
				j-=1
				c+=1
			end
			# espace si il y a de la place
			tab.unshift(0) if j>=0

			j-=1
			indice-=1
		end

		while j>=0
			tab.unshift(0)
			j-=1
		end

		return tab
	end

	# Extrémités du plateau
	def extremite(num, range)

		if range.eql?("column")   # pour une colonne
			taille = @lines.size()
			tabindice=@clns
		else                      # pour une ligne
			taille = @clns.size()
			tabindice=@lines
		end

		# De la gauche vers la droite
		j=0
		j+=1 while (get_grid("grid", num, j, range)==-1) && (j<(taille-1))
		if get_grid("grid", num, j, range)==1
			fin = tabindice[num][0]+j
			fin = taille-1 if fin>taille-1

			((j+1)...fin).each do |i|
				set_grid(num, i, 1, range)
			end
		end

		# De la droite vers la gauche
		j=taille-1
		j-=1 while (get_grid("grid", num, j, range)==-1) && (j>0)

		if get_grid("grid", num, j, range)==1
			fin = j
			debut = (fin-tabindice[num][tabindice[num].size()-1])+1
			debut = 0 if debut<0

			(debut...fin).each do |i|
				set_grid(num, i, 1, range)
			end
			set_grid(num, debut-1, -1, range) if debut>-1
		end
	end

	# Colorie les cases certaines d'une range
	def traiterrange(num, range)

		tab1 = premiere_possibilite(num, range)
		tab2 = deuxieme_possibilite(num, range)

		taille = range.eql?("column") ? @lines.size() : @clns.size()

		# Coloriage des cases sûres (intersection des 2 possibilités)
		(0...taille).each do |i|
			if tab1[i]==tab2[i] && tab1[i]>0
				set_grid(num, i, 1, range)
			end
		end

		extremite(num, "column")
		extremite(num, "line")
	end
end

# Grille 10x5 de la feuille
# l = [[1,2],[3],[4],[3],[5],[4],[2],[5],[4],[1]]
# c = [[1,2,1],[8],[8],[3,2,2],[1,1,2,3]]

# Speaker
# l = [[2],[3],[2,1],[2,1],[3,1],[4,1,1],[1,1,1],[1,1,1],[1,1,1],[4,1,1],[3,1],[2,1],[2,1],[3],[2]]
# c = [[1,1],[1,1],[1,1],[7],[1,1],[9],[2,2],[2,2],[2,2],[15]]

# Me
# l = [[2,3,2],[1,4,4,1],[6,6],[15],[3,3,1,3],[3,1,1,5],[3,1,1,1,4],[3,3,1,5],[2,3,1,2],[1,11,1],[2,9,2],[3,7,3],[4,5,4],[5,3,5],[6,1,6]]
# c = [[2,5,6],[1,7,5],[9,4],[3,2,3],[4,6,2],[5,6,1],[1,3,8],[1,1,6],[1,12],[3,4,1],[3,1,1,3,2],[3,3,2,3],[9,4],[1,7,5],[2,5,6]]

# Grille 5x5 de la feuille
l = [[3],[1],[3],[2,1],[1,2]]
c = [[1],[3],[1,2],[2,1],[1,2]]

soluce = Array.new(5) do
	Array.new(5) do
		-1
	end
end
soluce[0][2]=1
soluce[0][3]=1
soluce[0][4]=1
soluce[1][3]=1
soluce[2][0]=1
soluce[2][1]=1
soluce[2][2]=1
soluce[3][1]=1
soluce[3][2]=1
soluce[3][4]=1
soluce[4][1]=1
soluce[4][3]=1
soluce[4][4]=1

user = Array.new(5) do
	Array.new(5) do
		0
	end
end

user[0][2]=1
user[1][0]=-1
user[1][1]=-1
user[1][2]=-1
user[1][3]=1
user[1][4]=-1
user[2][1]=1
user[2][2]=1
user[3][0]=-1
user[3][1]=1
user[3][2]=1
user[3][3]=-1
user[3][4]=1
user[4][2]=-1
user[4][3]=1

test = Helper.new(soluce, l, c)
tab = test.traitement(user, 2)
print tab
puts("")

# Memo a faire :
# refactoriser le code avec codeclimate (en cours)
# commentaires mieux organisés + en anglais + code en anglais
