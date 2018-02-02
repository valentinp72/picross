require 'spec_helper'
require_relative '../src/Cell'

describe Grid do

	grid = Grid.new(5,5,"test") 

	it "initialize cell" do
		expect(grid.lines).to eq 5
		expect(grid.columns).to eq 5
		grid.grid.each do |lines|
			lines.each do |cell|
				expect(cell.state).to eq Cell::CELL_WHITE
			end
		end		
	end

	it "change cell state from the grid" do
		grid.getCellPosition(0,0).state = Cell::CELL_CROSSED
		expect(grid.getCellPosition(0,0).state).to eq Cell::CELL_CROSSED

		grid.getCellPosition(0,0).state = Cell::CELL_BLACK
		expect(grid.getCellPosition(0,0).state).to eq Cell::CELL_BLACK

		grid.getCellPosition(0,0).state = Cell::CELL_WHITE
		expect(grid.getCellPosition(0,0).state).to eq Cell::CELL_WHITE
	end

	it "should raise an error if going out of the grid" do
		expect{grid.getCellPosition(6,6).state}.to raise_error(Grid::InvalidCellPositionException)
	end


	it "should display the grid" do

		# We know that the first cell is empty
		grid.getCellPosition(0,0).state = Cell::CELL_WHITE
		string = grid.to_s
		expect(string[8]).to eq "█"
	
		grid.getCellPosition(0,0).state = Cell::CELL_CROSSED
		string = grid.to_s
		expect(string[8]).to eq "X"

		grid.getCellPosition(0,0).state = Cell::CELL_BLACK
		string = grid.to_s
		expect(string[8]).to eq "░"
	end
end
