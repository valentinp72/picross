##
# File          :: PicrossFrame.rb
# Author        :: PELLOIN Valentin
# Licence       :: MIT License
# Creation date :: 04/07/2018
# Last update   :: 10/07/2018
# Version       :: 0.1
# This class allows the game to be played using the keyboard.

class KeyboardDrag 

	# The X position the user is currently on
	attr_reader :posX
	attr_writer :posX

	# The Y position the user is currently on
	attr_reader :posY
	attr_writer :posY

	##
	# Create a new keyboard drag.
	# * *Arguments* :
	#   - +picrossFrame+ -> the PicrossFrame of the picross in game
	def initialize(picrossFrame)
		@picrossFrame = picrossFrame

		@posX = 0
		@posY = 0

		@keys = ["up", "down", "left", "right", "click-left", "click-right"]
		@picrossFrame.signal_connect('unrealize') do
			self.unsetKeys
		end
		
		self.setKeys
	end

	##
	# Sets all the keys to the drag
	# * *Returns* :
	#   - the object itself
	def setKeys
		keys = @picrossFrame.user.settings.picrossKeys
		@keys.each do |key|
			press   = "key_#{key.gsub('-', '_')}_pressed".to_sym
			release = "key_#{key.gsub('-', '_')}_released".to_sym
			@picrossFrame.toplevel.setKeyListener(
					keys[key],
					:pressMethod   => method(press), 
					:releaseMethod => method(release)
			)
		end
		return self
	end

	##
	# Unsets all the keys linked to the drag
	# * *Returns* :
	#   - the object itself
	def unsetKeys
		keys = @picrossFrame.user.settings.picrossKeys
		@keys.each do |key|
			@picrossFrame.toplevel.unsetKeyListener(keys[key])
		end
	end

	##
	# Returns the grid of the drag
	# * *Returns* :
	#   - the Grid of the KeyboardDrag
	def grid
		return @picrossFrame.grid
	end

	##
	# Ask to move the cursor in the given Y and X directions.
	# * *Arguments* :
	#   - +yDir+ -> the Y direction to move the cursor
	#   - +xDir+ -> the X direction to move the cursor
	# * *Returns* :
	#   - the object itself
	def moveDir(yDir, xDir)
		if self.grid.validPosition?(@posY + yDir, @posX + xDir) then
			@picrossFrame.leaveNotify(@posY, @posX)
			@posY += yDir
			@posX += xDir
		end
		@picrossFrame.enterNotify(@posY, @posX)
	end

	##
	# Action to do when the UP key is pressed
	# * *Returns* :
	#   - the object itself
	def key_up_pressed
		self.moveDir(-1, 0)
		return self
	end

	def key_up_released

	end

	##
	# Action to do when the DOWN key is pressed
	# * *Returns* :
	#   - the object itself
	def key_down_pressed
		self.moveDir(1, 0)
		return self
	end

	def key_down_released

	end

	##
	# Action to do when the LEFT key is pressed
	# * *Returns* :
	#   - the object itself
	def key_left_pressed
		self.moveDir(0, -1)
		return self
	end

	def key_left_released

	end

	##
	# Action to do when the RIGHT key is pressed
	# * *Returns* :
	#   - the object itself
	def key_right_pressed
		self.moveDir(0, 1)
		return self
	end

	def key_right_released

	end

	##
	# Action to do when the LEFT CLICK BUTTON key is pressed
	# * *Returns* :
	#   - the object itself
	def key_click_left_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_LEFT_CLICK)
		return self
	end

	##
	# Action to do when the LEFT CLICK BUTTON key is released
	# * *Returns* :
	#   - the object itself
	def key_click_left_released
		@picrossFrame.drag.reset
		return self
	end

	##
	# Action to do when the RIGHT CLICK BUTTON key is pressed
	# * *Returns* :
	#   - the object itself
	def key_click_right_pressed
		@picrossFrame.click(@posY, @posX, CellButton::BUTTON_RIGHT_CLICK)
		return self
	end

	##
	# Action to do when the RIGHT CLICK BUTTON key is released
	# * *Returns* :
	#   - the object itself
	def key_click_right_released
		@picrossFrame.drag.reset
		return self
	end

end
