require 'spec_helper'
require_relative '../src/User'

describe UserSettings do

	user = User.new("test",nil)

	userSettings = UserSettings.new(user)

	it "change language" do

		userSettings.language = 'francais'
		expect(userSettings.language).to eq 'francais'

		userSettings.language = 'english'
		expect(userSettings.language).to eq 'english'

		expect{userSettings.language = 'pirate'}.to raise_error(UserSettings::InvalidLanguageException)
	end

	it "change bind value" do
		userSettings.changeKeyBoardValue(50, "up")
		expect(userSettings.picrossKeys["up"]).to eq 50

		userSettings.changeKeyBoardValue(51, "down")
		expect(userSettings.picrossKeys["down"]).to eq 51

		userSettings.changeKeyBoardValue(52, "left")
		expect(userSettings.picrossKeys["left"]).to eq 52

		userSettings.changeKeyBoardValue(53, "right")
		expect(userSettings.picrossKeys["right"]).to eq 53

		userSettings.changeKeyBoardValue(54, "click-left")
		expect(userSettings.picrossKeys["click-left"]).to eq 54

		userSettings.changeKeyBoardValue(55, "click-right")
		expect(userSettings.picrossKeys["click-right"]).to eq 55
	end

	it "change unexisting bind value" do
		expect{userSettings.changeKeyBoardValue(19, "helloworld")}.to raise_error(UserSettings::InvalidBindException)
	end

	it "change hypothesis color" do
		userSettings.hypothesesColors= ["#000000", "#111111", "#222222", "#333333", "#444444"]
		expect(userSettings.hypothesesColors).to eq ["#000000", "#111111", "#222222", "#333333", "#444444"]
	end

	it "check if it's a valid color" do
		expect(userSettings.validColor? "#000000").to eq true
		expect(userSettings.validColor? "#aa1401").to eq true
		expect(userSettings.validColor? "#zzzzzz").to eq false
		expect(userSettings.validColor? "aa1401").to  eq false
		expect(userSettings.validColor? "helloworld").to eq false
	end

end
