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
		userSettings.changeKeyBoardValue(50,0)
		expect(userSettings.keyboardUp).to eq 50

		userSettings.changeKeyBoardValue(51,1)
		expect(userSettings.keyboardDown).to eq 51

		userSettings.changeKeyBoardValue(52,2)
		expect(userSettings.keyboardLeft).to eq 52

		userSettings.changeKeyBoardValue(53,3)
		expect(userSettings.keyboardRight).to eq 53

		userSettings.changeKeyBoardValue(54,4)
		expect(userSettings.keyboardClickLeft).to eq 54

		userSettings.changeKeyBoardValue(55,5)
		expect(userSettings.keyboardClickRight).to eq 55
	end

	it "change unexisting bind value" do
		expect{userSettings.changeKeyBoardValue(99,8)}.to raise_error(UserSettings::InvalidBindException)
	end

	it "change hypothesis color" do
		userSettings.hypothesesColors= ["#000000", "#111111", "#222222", "#333333", "#444444"]
		expect(userSettings.hypothesesColors).to eq ["#000000", "#111111", "#222222", "#333333", "#444444"]
	end

	it "check if it's a valid color" do
		expect(userSettings.validColor? "#000000").to eq true
		expect(userSettings.validColor? "#zzzzzz").to eq false
	end

end
