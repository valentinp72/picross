# Licence	:: MIT Licence
# Creation date	:: 01/27/2018
# Last update	:: 04/02/2018
#

require_relative 'Cell'
require_relative 'Grid'
require_relative 'Map'

class Helper


	#Variables d'instance
	@lines	#int[]
	@clns #int[]
	@grid #int[][]	#0 : case indéterminée, -1 : case cochée, 1 : case coloriée
	@solution #grille contenant la solution finale du picross
	
	#Constructeur
	def initialize(sol,line,col)

		@solution = sol
		#@solution = majSolution(map.solution)			#si map en parametre au lieu de sol
		@lines = line
		@clns = col

		#Initialisation de la grille
		@grid = Array.new(@lines.size()) do |j|
			Array.new(@clns.size()) do |i|
				0
			end
		end
	end


	#renvoie un tableau [[x1,y1,etat1],[x2,y2,etat2],...] indiquant les cases à colorier/cocher
	#x abscysse, y ordonnée, etat :  1=indéterminée / 2=coloriée / 3=cochée
	def traitement(userGrid, helpLvl)

		
		
		if(helpLvl==1)  			#Aide simple : Renvoit une ligne aléatoire non finie par l'utilisateur

			#Recherche une ligne aléatoire non complétée par l'utilisateur
			line = searchLine(userGrid)
			
			help = []
			for i in 0...@clns.size()

				help.push([line,i,convertState(@solution[line][i])])
			end
			return help

			
		else		
	
			#On place la grille de l'utilisateur dans la grille du solveur
			for i in 0...@lines.size()
				for j in 0...@clns.size()
			
					@grid[i][j] = userGrid[i][j];
				end
			end
			
			self.solve()
			
			if(helpLvl==2)			#Aide moyenne : Renvoit un groupe de cases que l'utilisateur aurait pu trouver facilement
			
				nbtour=0		#pour eviter boucle infinie si resultat introuvable
				
				while(nbtour<10)
				
					tabrange = rfull()
				
					for numl in tabrange[0]
					
						bloc = blocNotcomplete(numl,"line",userGrid,"grid")

						if(!bloc.empty?()) 
							return bloc
						end
					end
					
					for numc in tabrange[1]
					
						bloc2 = blocNotcomplete(numc,"column",userGrid,"grid")
						if(!bloc2.empty?()) 
							return bloc2
						end
					end
				
					self.solve()
				
					nbtour+=1
				end
				
				#si introuvable, on donne un bloc aléatoire de la solution que l'utilisateur n'a pas trouver
				puts("ALEATOIRE")
				
				for numl in 0...@lines.size()
					
					bloc = blocNotcomplete(numl,"line",userGrid,"solution")

					if(!bloc.empty?()) 
						return bloc
					end
				end
				
				for numc in 0...@clns.size()
					bloc2 = blocNotcomplete(numc,"column",userGrid,"solution")
					if(!bloc2.empty?()) 
					
						return bloc2
					end
				end

				return([[]])		#si toutes les cases sont déja bien coloriées, l'aide ne donne aucune solutions
				
			else 			#Aide difficile : Renvoit une case que l'utilisateur aurait pu trouver facilement

				i=0
				while (i<@lines.size())
			
					j=0
					while (j<@clns.size())
	
						if (@grid[i][j]==1 && userGrid[i][j]==0)
							
							return([[i,j,Cell::CELL_BLACK]])
						end
						j+=1
					end
					i+=1
				end

				#si introuvable, on donne une case aléatoire de la solution que l'utilisateur n'a pas trouver
				puts("ALEATOIRE :")
				for i in 0...@clns.size()
					for j in 0...@lines.size()
						
						if(@solution[i][j]==1 && userGrid[i][j]==0)
							return([[i,j,Cell::CELL_BLACK]])
						end
					end
				end
				return([[]])		#si toutes les cases sont déja bien coloriées, l'aide ne donne aucune solutions
			
			end
		end
	end
	
	#Convertit la grille de cellules finales en grille de solution d'entier
	def majSolution(cellGrid)
		
		soluce = Array.new(5) do |j|
			Array.new(5) do |i|
				-1
			end
		end
		
		for i in 0...@lines.size()
			
			for j in 0...@clns.size()
		
				if(cellGrid.cellPosition(i,j).state==CELL_BLACK)
					soluce[i][j]=1;
				end
			end
		end
		
		return soluce
	end
	
	#Convertit un entier représenté sur la grille par 0,-1 ou 1 en un état
	def convertState(entier)
	
		if(entier==1)
			return Cell::CELL_BLACK
		elsif(entier==0)
			return Cell::CELL_WHITE
		else
			return Cell::CELL_CROSSED
		end
	
	end
	
	#Renvoit un tableau des numéros de lignes et colonnes pleines de la grille
	def rfull()
	
		tabline = []
		tabcol = []
		
		#regarde si ligne pleine
		for i in 0...@lines.size()
				
			j=0
			while(j<@clns.size())
	
				if(@grid[i][j]==0)
				
					j=@clns.size()
	
				elsif(j==@clns.size()-1)		#si ligne pleine on push
					
					tabline.push(i)
				end
				j+=1
			end
		end
		
		#regarde si colonne pleine
		for i in 0...@clns.size()
				
			j=0
			
			while(j<@lines.size())
	
				if(@grid[j][i]==0)
				
					j=@lines.size()
					
				elsif(j==@lines.size()-1)		#si ligne pleine on push
					
					tabcol.push(i)
				end
				j+=1
				
			end
		end
		
		return ([tabline,tabcol])
	end
	
	#renvoit le premier bloc non complet de la grille de l'utilisateur, tableau vide sinon
	def blocNotcomplete(num,range,userGrid,matrix)
	
		bloc=false
		tab=[]
		if matrix.eql?("grid") then
			mat = @grid
		else
			mat = @solution
		end
		
		if range.eql?("column") then
	
			for i in 0...@lines.size()
				if(mat[i][num]==1)
				
					tab.push([i,num,Cell::CELL_BLACK])
					if(userGrid[i][num]==0)
						bloc=true
					end
					
				elsif(bloc==false)
					tab.clear()
				elsif(bloc==true)
					return tab
				end
			end
		else
		
			for i in 0...@clns.size()
	
				if(mat[num][i]==1)
					
					tab.push([num,i,Cell::CELL_BLACK])
					if(userGrid[num][i]==0)
						bloc=true
					end
				
				elsif(bloc==false)
					tab.clear()
				elsif(bloc==true)
					return tab
				end
			end
		end
		
		if (bloc==false)
			tab.clear()
		end
		return tab
	end

	#Recherche une ligne aléatoire non complétée par l'utilisateur
	def searchLine(userGrid)
	
		i=0
		tabl=[]
		
		#Met dans un tableau les numéros des lignes non complétées
		while (i<@lines.size())
			
			j=0
			while (j<@clns.size())
					
				if (userGrid[i][j]==0)
						
					tabl.push(i)
				end
				j+=1
			end
			i+=1
		end
	
		#Choisit aléatoirement un numéro de ligne dans le tableau (plus de chance d'avoir une des lignes les moins remplies)
		return tabl[Random.rand(tabl.size())]

	end
	
	#utilise les méthodes de résolution pour continuer la grille
	def solve
	
		self.afficher()
			
		#On coche les cases impossibles (on les met à -1)
		self.cochergrille()
			
		#On remplit les cases
		for i in 0...@clns.size()
			self.traiterrange(i,"column")
		end

		for i in 0...@lines.size()
			self.traiterrange(i,"line")
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

	#Renvoit vrai si le nombre de case coloriée sur une range est égal à celui attendu
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

	#Coche toute les cases indéterminées d'une ligne
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

#Grille 10x5 de la feuille
#l = [[1,2],[3],[4],[3],[5],[4],[2],[5],[4],[1]]
#c = [[1,2,1],[8],[8],[3,2,2],[1,1,2,3]]

#Speaker
#l = [[2],[3],[2,1],[2,1],[3,1],[4,1,1],[1,1,1],[1,1,1],[1,1,1],[4,1,1],[3,1],[2,1],[2,1],[3],[2]]
#c = [[1,1],[1,1],[1,1],[7],[1,1],[9],[2,2],[2,2],[2,2],[15]]

#Me
#l = [[2,3,2],[1,4,4,1],[6,6],[15],[3,3,1,3],[3,1,1,5],[3,1,1,1,4],[3,3,1,5],[2,3,1,2],[1,11,1],[2,9,2],[3,7,3],[4,5,4],[5,3,5],[6,1,6]]
#c = [[2,5,6],[1,7,5],[9,4],[3,2,3],[4,6,2],[5,6,1],[1,3,8],[1,1,6],[1,12],[3,4,1],[3,1,1,3,2],[3,3,2,3],[9,4],[1,7,5],[2,5,6]]

#Grille 5x5 de la feuille
l = [[3],[1],[3],[2,1],[1,2]]
c = [[1],[3],[1,2],[2,1],[1,2]]
		
soluce = Array.new(5) do |j|
		Array.new(5) do |i|
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

user = Array.new(5) do |j|
		Array.new(5) do |i|
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


test = Helper.new(soluce,l,c)
tab = test.traitement(user,3)
print tab
puts("")

#Memo a faire : 
#Remplacer solution en variable d'instance par une map (en cours)
#refactoriser le code (cf codeclimate)
#commentaires mieux organisés + en anglais + code en anglais
