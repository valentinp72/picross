require 'spec_helper'


describe Grid do

	grid = Grid.new(5,5) 

	it "initialize cell" do
		expect(grid.lines).to eq 5
		expect(grid.columns).to eq 5
		grid.grid.each do |lines|
			lines.each do |cell|
				expect(cell.state).to eq Cell::CELL_EMPTY
			end
		end		
	end

	it "should display the grid" do
		string = grid.to_s

		# We know that the first cell is empty
		expect(string[8]).to eq "░"
	end
end
