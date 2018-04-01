require 'spec_helper'

describe Statistic do

	stat = Statistic.new()

	it "useHelp" do
		stat.useHelp
		expect(stat.usedHelp).to eq 1
	end
end
