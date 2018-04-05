require 'spec_helper'

describe Map do

	defaultHypothesis = Hypothesis.new(nil, 0)
	solutionGrid = grid = Grid.new(10,10,"test")
	map = Map.new("test", 100, 3, 10, 10, solutionGrid)

	# it "load a map" do
	# 	puts path + "/batman.map"
	# 	map = Map.load(path + '/batman.map')
	# end
	#
	# it "save a map" do
	# 	map.save("batman")
	# end

	it "retrieve cell At(line, column) and click " do
		temp = map.currentStat.nbClick
		map.retrieveForRotateAt(0,0)

		expect(map.currentStat.nbClick).to eq temp+1
	end

	it "retrieve cell For Rotate At(line, column) " do
		map.grid.getCellPosition(0,0).state = Cell::CELL_WHITE


		map.rotateStateAt(0,0)

		expect(map.grid.getCellPosition(0,0).state).to eq Cell::CELL_BLACK
	end

	it "retrieve cell For InvertRotate At(line, column) " do
		map.grid.getCellPosition(0,0).state = Cell::CELL_WHITE

		map.rotateStateInvertAt(0,0)

		expect(map.grid.getCellPosition(0,0).state).to eq Cell::CELL_CROSSED
	end

	it "retrieve cell For rotateStateAt (line, column) " do
		map.grid.getCellPosition(0,0).state = Cell::CELL_BLACK

		map.rotateToStateAt(0,0, Cell::CELL_WHITE)

		expect(map.grid.getCellPosition(0,0).state).to eq Cell::CELL_WHITE
	end

	it "should the map finish? the map" do
		map.grid.getCellPosition(0,0).state = Cell::CELL_BLACK
		expect(map.shouldFinish?).to eq false

		map.grid.getCellPosition(0,0).state = Cell::CELL_WHITE
		expect(map.shouldFinish?).to eq true
	end

	it "check map" do
		map.grid.getCellPosition(0,0).state = Cell::CELL_BLACK
		expect(map.check).to eq false

		map.grid.getCellPosition(0,0).state = Cell::CELL_WHITE
		expect(map.check).to eq true
	end

	it "check if map will evolve" do
		expect(map.evolving?).to eq false
	end

	it "reset the map" do
		map.reset

		expect(map.currentStat.nbClick).to eq 0
	end

	it "print map" do
		expect(map.to_s).to eq map.to_s
	end


end
