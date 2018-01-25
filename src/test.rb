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
=begin
hy = Hypotheses.new(5, 5)
print hy

hy.getWorkingHypothesis.grid.getCellPosition(0,0).stateRotate()
print hy

h = hy.addNewHypothesis()
hy.getWorkingHypothesis.grid.getCellPosition(1,1).stateRotate()
print hy
hy.validate(h)
print hy
=end
require_relative 'Map'

solution = Grid.new(5, 5)
map1 = Map.new(60, 1, 5, 5, solution)
puts map1
rslt = map1.save()
map2 = Map.load(rslt)
puts map2
