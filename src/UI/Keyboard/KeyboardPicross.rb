class KeyboardPicross

	attr_accessor :posX
	attr_accessor :posY

	def initialize(picrossFrame, user, map)
		@frame = picrossFrame
		@user = user
		@map = map

		@posX = 0
		@posY = 0

		@enterDown = false
		@gaucheDown = false
		@hautDown = false
		@droiteDown = false
		@basDown = false
	end

	def leftClick(event)
		# Left click
		if event.type == Gdk::EventType::KEY_PRESS && !@enterDown then
			@enterDown = true
			@frame.enterNotify(@posX,@posY)
			@frame.click(@posX,@posY,CellButton::BUTTON_LEFT_CLICK)
		elsif event.type == Gdk::EventType::KEY_RELEASE && @enterDown then
			@enterDown = false
			@frame.unclick(@posX,@posY)
		end
	end

	def rightClick(event)
		# Right click
		if event.type == Gdk::EventType::KEY_PRESS && !@enter_down then
			@enter_down = true
			@frame.enterNotify(@posX,@posY)
			@frame.click(@posX,@posY,CellButton::BUTTON_RIGHT_CLICK)
		elsif event.type == Gdk::EventType::KEY_RELEASE && @enter_down then
			@enter_down = false
			@frame.unclick(@posX,@posY)
		end
	end

	def moveLeft(event)
		# left touch
		if event.type == Gdk::EventType::KEY_PRESS && !@gaucheDown && @map.hypotheses.getWorkingHypothesis.grid.validPosition?(@posX-1, @posY) then
			@frame.leaveNotify(@posX,@posY)
			@posX -= 1
			@frame.enterNotify(@posX,@posY)
			@gaucheDown = true
		elsif  event.type == Gdk::EventType::KEY_RELEASE && @gaucheDown then
			@gaucheDown = false
		end
	end

	def moveUp(event)
		# up touch
		if event.type == Gdk::EventType::KEY_PRESS && !@hautDown && @map.hypotheses.getWorkingHypothesis.grid.validPosition?(@posX, @posY-1) then
			@frame.leaveNotify(@posX,@posY)
			@posY -= 1
			@frame.enterNotify(@posX,@posY)
			@hautDown = true
		elsif  event.type == Gdk::EventType::KEY_RELEASE && @hautDown then
			@hautDown = false
		end
	end

	def moveRight(event)
		# right touch
		if event.type == Gdk::EventType::KEY_PRESS && !@droiteDown && @map.hypotheses.getWorkingHypothesis.grid.validPosition?(@posX+1, @posY) then
			@frame.leaveNotify(@posX,@posY)
			@posX += 1
			@frame.enterNotify(@posX,@posY)
			@droiteDown = true
		elsif  event.type == Gdk::EventType::KEY_RELEASE && @droiteDown then
			@droiteDown = false
		end
	end

	def moveDown(event)
		# down touch
		if event.type == Gdk::EventType::KEY_PRESS && !@basDown && @map.hypotheses.getWorkingHypothesis.grid.validPosition?(@posX, @posY+1) then
			@frame.leaveNotify(@posX,@posY)
			@posY += 1
			@frame.enterNotify(@posX,@posY)
			@basDown = true
		elsif  event.type == Gdk::EventType::KEY_RELEASE && @basDown then
			@basDown = false
		end
	end

	def on_key_press_event(event)
		if event.keyval == @user.settings.keyboardClickLeft then
			leftClick(event)
		elsif event.keyval == @user.settings.keyboardClickRight then
			rightClick(event)
		elsif event.keyval == @user.settings.keyboardLeft then
			moveLeft(event)
		elsif event.keyval == @user.settings.keyboardUp then
			moveUp(event)
		elsif event.keyval == @user.settings.keyboardRight then
			moveRight(event)
		elsif event.keyval == @user.settings.keyboardDown then
			moveDown(event)
		end
	end
end
