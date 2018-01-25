require 'spec_helper'


describe Cell do

	cell = Cell.new 

	it "initialize cell" do
		expect(cell.state).to eq CELL_EMPTY
	end
	it "change cell state to crossed" do
		cell.state = CELL_CROSSED
		except(cell.state).to eq CELL_CROSSED
	end
	it "change cell state to full" do
		cell.state = CELL_FULL
		except(cell.state).to eq CELL_FULL
	end
	it "should raise" do
    expect{cell.state=3}.to raise_error(ArgumentError)
  end	

end
