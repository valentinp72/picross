require 'spec_helper'


describe Grid do

	grid = Grid.new(10,10) 

	it "initialize cell" do
		expect(grid.lines).to eq 10
		expect(grid.columns).to eq 10
		grid.grid.each do |lines|
			lines.each do |cell|
				expect(cell.state).to eq Cell::CELL_EMPTY
			end
		end		
	end

	it "should display the grid" do
		string = grid.to_s
		# We know that the first cell is empty
		expect(string[0][0]).to eq " "
	end
end
