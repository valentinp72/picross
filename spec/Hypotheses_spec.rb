require 'spec_helper'

describe Grid do

	hypotheses = Hypotheses.new(10,10)

	defaultHypothesis      = Hypothesis.new(nil)
	defaultGrid            = Grid.new(lines, columns, defaultHypothesis)
	defaultHypothesis.grid = defaultGrid

	it "initialize hypotheses" do
		expect(hypotheses).to eq hypotheses
	end

	it "retrieve the working hypothesis"
		expect(hypotheses.getWorkingHypothesis).to eq  defaultHypothesis
	end

	it "create a new hypothesis" do
		expect(hypotheses.addNewHypothesis).to eq 1
	end

	it "reject the last hypothesis" do
		expect(hypotheses.reject(1)).to eq hypotheses
	end
end
