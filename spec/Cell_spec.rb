require 'spec_helper'


describe Cell do

	cell = Cell.new 

	it "initialize cell" do
		expect(cell.state).to eq Cell::CELL_EMPTY
	end

	it "change cell state to crossed" do
		cell.state = Cell::CELL_CROSSED
		expect(cell.state).to eq Cell::CELL_CROSSED
	end

	it "change cell state to full" do
		cell.state = Cell::CELL_FULL
		expect(cell.state).to eq Cell::CELL_FULL
	end

	it "should raise" do
    	expect{cell.state=3}.to raise_error(ArgumentError)
  	end	

end
