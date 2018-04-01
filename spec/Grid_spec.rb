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

	it "change the hypothesis" do
		grid_2 = Grid.new(5,10,"test")
		hypo = Hypothesis.new(grid_2, 0)
		grid_2.hypothesis=hypo

		grid_2.each_cell do |cell|
			expect(cell.hypothesis).to eq hypo
		end
	end

	it "change cell at the position" do
		grid.getCellPosition(0,0).state = Cell::CELL_CROSSED

		expect(grid.getCellPosition(0,0).state).to eq Cell::CELL_CROSSED

		grid.getCellPosition(1,1).state = Cell::CELL_BLACK
		grid.setCellPosition(0, 0, grid.getCellPosition(1,1) )

		expect(grid.getCellPosition(0,0).state).to eq Cell::CELL_BLACK

		expect{grid.setCellPosition(-1,-1,grid.getCellPosition(1,1))}.to raise_error(Grid::InvalidCellPositionException)
	end

	it "loop through each cell with index" do
		grid.each_cell_with_index do |cell,k,l|
			expect(cell).to eq grid.getCellPosition(k, l)
		end
	end

	it "test line containing" do
		line = grid.lineContaining(grid.grid[0][0])
		expect(line).to eq grid.grid[0]

		grid_2 = Grid.new(10,10)
		hypo = Hypothesis.new(grid_2, 0)
		cell = Cell.new(hypo, 0, 0)

		expect{grid.lineContaining(cell)}.to raise_error(Grid::CellNotInGridException)

	end

	it "test column containing" do
		column = grid.columnContaining(grid.grid[0][0])
		expect(column).to eq grid.grid.transpose[0]

		grid_2 = Grid.new(10,10)
		hypo = Hypothesis.new(grid_2, 0)
		cell = Cell.new(hypo, 0, 0)

		expect{grid.columnContaining(cell)}.to raise_error(Grid::CellNotInGridException)
	end

	it "test totalLengthVertical" do
		expect(grid.totalLengthVertical(grid.grid[4][9])).to eq 5
	end

	it "test totalLengthHorizontal" do
		expect(grid.totalLengthHorizontal(grid.grid[4][9])).to eq 10
	end

	it "test totalLengthIntern" do
		expect(grid.totalLengthIntern(grid.grid[4], grid.grid[4][9])).to eq 10
	end

	it "test replaceAll" do
		grid.replaceAll(Cell::CELL_BLACK, Cell::CELL_WHITE)
		grid.replaceAll(Cell::CELL_CROSSED, Cell::CELL_WHITE)

		grid.each_cell do |cell|
			expect(cell.state).to eq Cell::CELL_WHITE
		end
	end

	it "test numberOfSameStates" do
		expect(grid.numberOfSameStates(grid.grid[0], Cell::CELL_WHITE)).to eq 10
	end


	it "test limit grid size" do

		expect{grid.limit(20,20)}.to raise_error(Grid::InvalidResizeSizeException)

		grid.limit(5,5)
		expect(grid.lines).to eq 5
		expect(grid.columns).to eq 5
	end

	it "test grow grid size" do

		expect{grid.grow(2,2)}.to raise_error(Grid::InvalidResizeSizeException)

		grid.grow(6,10)
		expect(grid.lines).to eq 6
		expect(grid.columns).to eq 10
	end

	it "compare two grids" do
		grid_2 = Grid.new(6,10,"test2")
		expect(grid.compare(grid_2)).to eq true
	end

	it "count cell of that state" do
		expect(grid.numberCell(Cell::CELL_WHITE)).to eq 60
	end

	it "finish the grid" do
		grid.getCellPosition(0,0).state = Cell::CELL_CROSSED

		grid.finish

		grid.each_cell do |cell|
			expect(cell.state).to eq Cell::CELL_WHITE or eq Cell::CELL_BLACK
		end
	end

	it "test marshal load/dump" do
		temp = Marshal.dump(grid)
		temp2 = Marshal.load(temp)
		expect(grid.compare(temp2)).to eq true
	end

end
