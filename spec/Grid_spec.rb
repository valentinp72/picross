require 'spec_helper'
require_relative '../src/Cell'

describe Grid do

	grid = Grid.new(5,10,"test") 

	it "initialize cell" do
		expect(grid.lines).to eq 5
		expect(grid.columns).to eq 10
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
		
		expect = "  0123456789\n" \
				 "00██████████\n" \
				 "01██████████\n" \
				 "02██████████\n" \
				 "03██████████\n" \
				 "04██████████\n"

		grid.getCellPosition(0,0).state = Cell::CELL_WHITE
		expect(grid.to_s).to eq expect
	
		expect = "  0123456789\n" \
				 "00██████████\n" \
				 "01██████████\n" \
				 "02██████████\n" \
				 "03X█████████\n" \
				 "04██████████\n"

		grid.getCellPosition(3,0).state = Cell::CELL_CROSSED
		expect(grid.to_s).to eq expect

		expect = "  0123456789\n" \
				 "00████░█████\n" \
				 "01██████████\n" \
				 "02██████████\n" \
				 "03X█████████\n" \
				 "04██████████\n"

		grid.getCellPosition(0,4).state = Cell::CELL_BLACK
		expect(grid.to_s).to eq expect
	end

	it "loop through each line" do
		expectedLines = grid.grid
		i = 0
		grid.each_line do |line|
			expect(line).to eq expectedLines[i]
			i += 1
		end
	end

	it "loop through each column" do
		expectedColumns = grid.grid.transpose
		i = 0
		grid.each_column do |column|
			expect(column).to eq expectedColumns[i]
			i += 1
		end
	end

	it "loop through each cell" do
		i = 0
		j = 0
		grid.each_cell do |cell|
			expect(cell).to eq grid.getCellPosition(j, i)
			i += 1
			if i >= grid.columns then
				i = 0
				j += 1
			end
		end
	end

end
