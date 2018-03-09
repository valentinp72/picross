##
# File          :: Resolver.rb
# Author        ::
# Licence       :: MIT Licence
# Creation date :: 01/27/2018
# Last update   :: 09/08/2018
#
# This class représente a picross solver.
# This solver will be used for the realization of the help system.

class Solver

	@linesTab	#int[]
	@columnsTab #int[]
	@gridTempo #int[][]	#0 : case indéterminée, -1 : case cochée, 1 : case coloriée

	##
	# Initialization of the instance variables
	#
	# TODO : Recover the player's current grid
	def initialize()
		@linesTab = [[3],[1],[3],[2,1],[1,2]]
		@columnsTab = [[1],[3],[1,2],[2,1],[1,2]]

		@gridTempo = Array.new(@linesTab.size()) do |j|
			Array.new(@columnsTab.size()) do |i|
				0
			end
		end
	end

	##
	# General processing of the resolution
	#
	# TODO : Make the method more modular
	def processing()
		columns_Size = @columnsTab.size()
		lines_Size = @linesTab.size()
		sum=0
		totalNumbBox=0		#total number of boxes to color on the grid
		tabResLin = []
		tabResCol = []

		for i in @linesTab
			for j in i
				sum=sum+j
				totalNumbBox += j
			end
			tabResLin.push(lines_Size-(sum+(i.size()-1)))
			sum=0
		end

		for i in @columnsTab
			for j in i
				sum=sum+j
			end
			tabResCol.push(columns_Size-(sum+(i.size()-1)))
			sum=0
		end

		# Color boxes where hints fully filled a line
		for i in 0...lines_Size
			j=0
			@linesTab[i].each do |block|
				for c in 1..block
					if(c>tabResLin[i])
						@gridTempo[i][j]=1
					end
					j+=1
				end
				j+=1
			end
		end

		# Color boxes where hints fully filled a column
		for i in 0...columns_Size
			j=0
			@columnsTab[i].each do |block|
				for c in 1..block
					if(c>tabResCol[i])
						@gridTempo[j][i]=1
					end
					j+=1
				end
				j+=1
			end
		end


    		for i in 0...lines_Size
      			if (self.counterColorLine(i))
        			self.tickLineBoxes(i)
      			end
    		end

    		for i in 0...columns_Size
      			if (self.counterColorCol(i))
        			self.tickColumnBoxes(i)
      			end
    		end


		self.colorieligne(4)

	end



	##
	# Display of the temporary grid
	# X -> boxes sure not to color
	# 0 -> boxes sure to color
	# - -> unprocessing boxes
	def display()
		i=0
		while(i<@linesTab.size())
			j=0
			while(j<@columnsTab.size())			
        			if(@gridTempo[i][j] == 1)
          				print "0"
       				elsif @gridTempo[i][j] == -1
          				print "X"
        			else
          				print "-"
       				end
					print " "
				j = j+1
			end
			i = i+1
			puts""
		end
	end


	##
	# Method to determine if a box should be colored.
	# Based on the number of colored boxes on a column
	# * *Arguments* :
	#   - +columnNumber+    -> an integer representing the column's number
	# * *Returns* :
	#   - a boolean
  	def counterColorCol(columnNumber)
   		counter = 0
    		counter2 = 0
    		for i in 0...@linesTab.size()
        		if @gridTempo[i][columnNumber] == 1
          			counter += 1
        		end
    		end

    		for i in 0...@columnsTab[columnNumber].size()
      			counter2 += @columnsTab[columnNumber][i]
    		end

    		if counter == counter2
      			return true
    		else
      			return false
    		end
  	end

	##
	# Method to determine if a box should be colored.
	# Based on the number of colored boxes on a line
	# * *Arguments* :
	#   - +lineNumber+    -> an integer representing the line's number
	# * *Returns* :
	#   - a boolean
 	def counterColorLine(lineNumber)
		counter = 0
   		counter2 = 0
    		for i in 0...@columnsTab.size()
     			if @gridTempo[lineNumber][i] == 1
          			counter += 1
        		end
    		end

    		for i in 0...@linesTab[lineNumber].size()
      			counter2 += @linesTab[lineNumber][i]
    		end
    		if counter == counter2
      			return true
    		else
      			return false
    		end
  	end

	##
	# Declare a box on a line as "false" (X)
	# * *Arguments* :
	#   - +lineNumber+    -> an integer representing the line's number
	def tickLineBoxes(lineNumber)
  		for i in 0...@columnsTab.size()
    			if @gridTempo[lineNumber][i]==0 then
      				@gridTempo[lineNumber][i]=-1
    			end
  		end
	end

	##
	# Declare a box on a column as "false" (X)
	# * *Arguments* :
	#   - +columnNumber+    -> an integer representing the column's number
	def tickColumnBoxes(columnNumber)
  		for i in 0...@linesTab.size()
    			if @gridTempo[i][columnNumber]==0 then
      				@gridTempo[i][columnNumber]=-1
    			end
  		end
	end

	##
	# Calculate the number of boxes already colored on the grid
	# * *Returns* :
	#   - the number of colored boxes
	def numbColoredBoxes()
		nb=0
		for i in 0...@linesTab.size()
			for j in 0...columnsTab.size()
				if(@gridTempo[i][j] == 1) then
					nb += 1
				end
			end
		end
		return nb
	end


	##
	#
	#
	# * *Arguments* :
	#   - +lineNumber+    -> an integer representing the line's number
  	def colorieligne(lineNumber)

		tab1 = Array.new
		tab2 = Array.new
		temp = 0

		tabHint = @linesTab[lineNumber]
		tabHintReverse = @linesTab[lineNumber].reverse

		print tabHint
		puts
		for i in 0...tabHint.size
			while temp != tabHint[i]
				tab1.push("0")
				temp+=1
			end
			tab1.push("X")
			temp = 0
		end
		print tab1
		puts

		for i in 0...tabHintReverse.size
			while temp != tabHintReverse[i]
				tab2.unshift("0")
				temp+=1
			end
			tab2.unshift("X")
			temp = 0
		end
		print tab2
		puts

	end

end


test = Resolver.new()
test.processing()
test.display()
