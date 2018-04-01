require 'spec_helper'

describe Timer do

	timer = Timer.new()

	it "starts the timer" do
		timer.start
		expect(timer.isRunning).to eq true
	end

	it "pause the timer" do
		timer.pause
		expect(timer.isRunning).to eq false
	end
end
