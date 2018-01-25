require_relative 'Grid.rb'

grid = Grid.new(5, 5)
print "Affichage de la grille : \n"
print grid

while true do
	gets
	grid.getCellPosition(0,0).stateRotate()
	print "Affichage de la grille : \n"
	print grid
end
