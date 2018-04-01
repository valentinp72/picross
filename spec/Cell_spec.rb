require 'spec_helper'
require_relative '../src/Grid'
require_relative '../src/Hypothesis'

describe Cell do

	grid = Grid.new(10,10)
	hypo = Hypothesis.new(grid, 0)

	cell = Cell.new(hypo, 0, 0)

	it "initialize cell" do
		expect(cell.state).to eq Cell::CELL_WHITE
	end

	it "should display the cell" do
			expect(cell.to_s).to eq "█"

			cell.state = Cell::CELL_WHITE
			expect(cell.to_s).to eq "█"

			cell.state = Cell::CELL_CROSSED
			expect(cell.to_s).to eq "X"

			cell.state = Cell::CELL_BLACK
			expect(cell.to_s).to eq "░"
	end

	it "test all cell states" do
		cell.state = Cell::CELL_BLACK
		expect(cell.state).to eq Cell::CELL_BLACK

		cell.state = Cell::CELL_WHITE
		expect(cell.state).to eq Cell::CELL_WHITE

		cell.state = Cell::CELL_CROSSED
		expect(cell.state).to eq Cell::CELL_CROSSED
	end

	it "test cell rotate" do
		cell.state = Cell::CELL_WHITE
		cell.stateRotate()
		expect(cell.state).to eq Cell::CELL_BLACK

		cell.stateRotate()
		expect(cell.state).to eq Cell::CELL_WHITE
	end

	it "test cell rotateInvert" do
		cell.state = Cell::CELL_WHITE
		cell.stateInvertCross()
		expect(cell.state).to eq Cell::CELL_CROSSED

		cell.stateInvertCross()
		expect(cell.state).to eq Cell::CELL_WHITE
	end

	it "test cell compare" do
		cell_1 = Cell.new(hypo, 0, 0)
		cell_2 = Cell.new(hypo, 0, 0)

		cell_1.state = Cell::CELL_WHITE
		cell_2.state = Cell::CELL_WHITE
		expect(cell_1.compare(cell_2)).to eq true

		cell_1.state = Cell::CELL_WHITE
		cell_2.state = Cell::CELL_CROSSED
		expect(cell_1.compare(cell_2)).to eq true

		cell_1.state = Cell::CELL_CROSSED
		cell_2.state = Cell::CELL_CROSSED
		expect(cell_1.compare(cell_2)).to eq true

		cell_1.state = Cell::CELL_BLACK
		cell_2.state = Cell::CELL_BLACK
		expect(cell_1.compare(cell_2)).to eq true

		cell_1.state = Cell::CELL_BLACK
		cell_2.state = Cell::CELL_CROSSED
		expect(cell_1.compare(cell_2)).to eq false

		cell_1.state = Cell::CELL_WHITE
		cell_2.state = Cell::CELL_BLACK
		expect(cell_1.compare(cell_2)).to eq false
	end

	it "test marshal load/dump" do
		temp = Marshal.dump(cell)
		temp2 = Marshal.load(temp)
		expect(cell.compare(temp2)).to eq true
	end

	it "should raise" do
		expect{cell.state=3}.to raise_error(ArgumentError)
	end


end
