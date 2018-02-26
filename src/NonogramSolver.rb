
class Resolver

	@lines	#int[]
	@clns #int[]
	@grid #int[][]

	

	def initialize()

		@lines = [[5],[3],[1],[3],[5]]
		@clns = [[1,1],[2,2],[5],[2,2],[1,1]]

		@grid = Array.new(@lines.size()) do |j|
			Array.new(@clns.size()) do |i| 
				false
			end
		end	
	end

	
	def traitement()

		tcln = @clns.size()
		tline = @lines.size()
		somme=0
		tabResLin = []
		tabResCol = []
		
	
		
=begin
		for i in @clns	#pour chaque colonne
			for j in i	#pour chaque indice
				
				somme=somme+j		#somme des indices
			end

			tabres.push(tcln-(somme+(i.size()-1)))
			somme=0
		end

		#parcours
		for elem in tabres
			puts elem
		end

=end	
		for i in @lines	#pour chaque colonne
			for j in i	#pour chaque indice
				
				somme=somme+j		#somme des indices
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
		
		for i in 0...tline
			j=0
			
			puts "tabResLin="+tabResLin[i].to_s
			@lines[i].each do |block|
				for c in 1..block
					if(c>=tabResLin[i])
						@grid[i][j]=true
					end
					puts "j="+j.to_s
					puts "c="+c.to_s
					j+=1
				end
				j+=1
				
				#puts "block="+block.to_s
			end	
			
		end

		for i in 0...tcln
			j=0
			@clns[i].each do |block|
				for c in 1..block
					if(c>=tabResCol[i])
						@grid[j][i]=true
					end
					#puts "tabResCol="+tabResCol[i].to_s
					#puts "j="+j.to_s
					#puts "c="+c.to_s
					j+=1
				end
				j+=1
	
				#puts "block="+block.to_s
			end	
			
		end
		

	end

	def afficher()

		i=0

		while(i<@lines.size())
			
			j=0
			while(j<@clns.size())
			
			
				print (@grid[i][j]? "O": " ")
				print " "
				j = j+1
			end
			i = i+1
			puts""
		end
	end





end

test = Resolver.new()
test.traitement()
test.afficher()
