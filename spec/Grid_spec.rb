require 'spec_helper'


describe Grid do

	grid = Grid.new(10,10) 

	it "initialize cell" do
		expect(grid.lines).to eq 10
		expect(grid.columns).to eq 10
		grid.grid.each do |lines|
			lines.each do |cell|
				except(cell.state).to eq CELL_EMPTY
			end
		end		
	end
end
