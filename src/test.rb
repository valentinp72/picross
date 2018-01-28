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

puts "Create hypotheses"
hy = Hypotheses.new(5, 5)
print hy

puts "Change 0,0 in hypothesis 0"
hy.getWorkingHypothesis.grid.getCellPosition(0,0).stateRotate()
print hy

puts "Add new hypothesis, change 1,1 inside"
h = hy.addNewHypothesis()
hy.getWorkingHypothesis.grid.getCellPosition(1,1).stateRotate()
print hy
puts "Reject last hypothesis"
hy.reject(h)
print hy

puts "Add new hypothesis, change 3,1 inside"
h = hy.addNewHypothesis()
hy.getWorkingHypothesis.grid.getCellPosition(3,1).stateRotate()
print hy
puts "Validate last hypothesis"
hy.validate(h)
print hy

puts "Add new hypothesis, change 2,1 inside"
h = hy.addNewHypothesis()
hy.getWorkingHypothesis.grid.getCellPosition(2,1).stateRotate()
print hy
puts "Validate last hypothesis"
hy.validate(h)
print hy



#h = hy.addNewHypothesis()
#hy.getWorkingHypothesis.grid.getCellPosition(1,2).stateRotate()
#hy.getWorkingHypothesis.grid.getCellPosition(1,1).stateRotate()
#print hy
#=end

=begin
require_relative 'Map'

solution = Grid.new(5, 5)
map1 = Map.new(60, 1, 5, 5, solution)
puts map1
rslt = map1.save()
map2 = Map.load(rslt)
puts map2
=end

require_relative 'Map'


solution = Grid.new(5, 5, "solution")
solution.randomCells
print "Solution : \n", solution

map = Map.new(60, 1, 5, 5, solution)
map.rotateStateAt(0, 0)
print map

newHypo = map.hypotheses.addNewHypothesis()
map.rotateStateAt(0, 0)
print map
map.hypotheses.reject(newHypo)
print map
