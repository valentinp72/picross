require_relative 'Grid.rb'
=begin
grid = Grid.new(5, 5)
print "Affichage de la grille : \n"
print grid

while true do
	gets
	grid.getCellPosition(0,0).stateRotate()
	print "Affichage de la grille : \n"
	print grid
end
=end
require_relative 'Hypotheses'

hy = Hypotheses.new(5, 5)
print hy

hy.getWorkingHypothesis.grid.getCellPosition(0,0).stateRotate()
print hy

h = hy.addNewHypothesis()
hy.getWorkingHypothesis.grid.getCellPosition(1,1).stateRotate()
print hy
hy.validate(h)
print hy
