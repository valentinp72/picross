require_relative 'TimerUI'

class TimerPenalty < TimerUI

	def markup(text)
		return "<span color='#{@color}'>#{text}</span>"
	end

	def text
		if @map.currentStat.penalty.seconds > 0 then
			@color = 'orange'
		else
			@color = 'black'
		end
		return '  ' + @map.currentStat.penalty.elapsedTime
	end

end
