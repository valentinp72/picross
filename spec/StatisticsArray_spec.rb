require 'spec_helper'

describe StatisticsArray do

	statArray = StatisticsArray.new()
	stat = Statistic.new()
	stat.start
	stat.finish(600)

	tempArray = [stat, Statistic.new() ,Statistic.new()]

	it "add statistic" do
		statArray.addStatistic(stat)
		expect(statArray.getLastStatistic).to eq stat
	end

	it "get last statistic" do
		temp = statArray.getLastStatistic

		expect(temp).to eq stat
	end

	it "loop through the array of statistic" do
		statArray.addStatistic(tempArray[1])
		statArray.addStatistic(tempArray[2])

		i = 0
		statArray.each do |st|
			expect(st).to eq tempArray[i]
			i += 1
		end
	end

	it "retrieve statArray length" do
		expect(statArray.length).to eq 3
	end

	it "retrieve stat with less used help" do
		expect(statArray.minHelp).to eq stat
	end

	it "retrieve stat with best time" do
		expect(statArray.bestTime).to eq tempArray[1]
	end

	it "retrieve stat with max stars" do
		expect(statArray.minHelp).to eq stat
	end

	it "retrieve stat with minClick" do
		expect(statArray.minClick).to eq stat
	end

	it "retrieve number of stat finished" do
		expect(statArray.nbFinished).to eq 1
	end

end
