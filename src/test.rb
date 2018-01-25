require_relative 'Grid.rb'

grid = Grid.new(5, 5)
print "Affichage de la grille : \n"
print grid

grid.getCellPosition(0, 1).state = Cell::CELL_FULL
print "Affichage de la grille : \n"
print grid

