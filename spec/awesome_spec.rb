require 'spec_helper'

# Test of Awesome class
describe Awesome do

	# We ensure that smile() return :)
	it "smiles" do
		emoji = Awesome.new()
		expect(emoji.smile).to eq ":"
	end

end
