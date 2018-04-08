require_relative 'Cell'
require_relative 'Grid'
require_relative 'Map'

##
# File          :: Solver.rb
# Licence       :: MIT License
# Creation date :: 01/27/2018
# Last update   :: 04/05/2018
# Version       :: 0.1
#
# Represent a Solver use in the helper
class Solver

	# Variables d'instance
	# @lines		int[]
	# @clns 		int[]
	# @grid 		int[][]	0 : case indéterminée, -1 : case cochée, 1 : case coloriée
	# @solution 	grille contenant la solution finale du picross

	#Constructeur
	def initialize(sol, line, col)
		
		@solution = sol		
		@lines = line
		@clns = col
		
		# Initialisation de la grille
		@grid = Array.new(@lines.size()) do
			Array.new(@clns.size()) do
				0
			end
		end
	end
	
	# utilise les méthodes de résolution pour continuer la grille
	def solve(grid)
	
		# On place la grille de l'utilisateur dans la grille du solveur
		(0...@lines.size()).each do |i|
			(0...@clns.size()).each do |j|

				@grid[i][j] = grid[i][j]
			end
		end
		
		# On coche les cases impossibles (on les met à -1)
		self.cochergrille()
		
		# On remplit les cases
		(0...@clns.size()).each do |i|
			self.traiterrange(i, "column")
		end
		
		(0...@lines.size()).each do |i|
			self.traiterrange(i, "line")
		end
		return @grid
	end

	# Retourne la valeur d'une grille (@grid ou @solution) en fonction de la range
	# en paramètre (ligne ou colonne)
	def get_grid(mat, numl, numc, range)

		grid = if mat.eql?("grid")
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

		# Calcul nombre de cases dans la range
		(0...taille).each do |i|
			cpt += 1 if self.get_grid("grid", num, i, range)==1
		end

		# Calcul de la somme des indices d'une range
		(0...tabTemp[num].size()).each do |i|
			cpt2 += tabTemp[num][i]
		end

		unless cpt == cpt2
			return false
		else
			return true
		end
	end
	
	# Coche toute les cases indéterminées d'une ligne
	def coche_case_indeter(num, range)

		taille = range.eql?("column") ? @lines.size() : @clns.size()

		# Parcours de la range et si case indéterminée on met une croix
		(0...taille).each do |i|
			self.set_grid(num, i, -1, range) if self.get_grid("grid", num, i, range).zero?
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

		extremite_gauche(tabindice, taille, num, range)
		extremite_droite(tabindice, taille, num, range)
	end
	
	# Traite le bord gauche de la grille
	def extremite_gauche(tabindice, taille, num, range)
		
		j=0
		j+=1 while (get_grid("grid", num, j, range)==-1) && (j<(taille-1))
		if get_grid("grid", num, j, range)==1
			fin = tabindice[num][0]+j
			fin = taille-1 if fin>taille-1

			((j+1)...fin).each do |i|
				set_grid(num, i, 1, range)
			end
		end
	end
	
	#Traite le bord droit de la grille
	def extremite_droite(tabindice, taille, num, range)
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
end