require_relative 'TimerUI'

class TimerRemaining < TimerUI

	def markup(text)
		return "<span color='#{@color}'><b>#{text}</b></span>"
	end

	def text
		timer = @map.currentStat.time
		sign  = '  '
		remaining = timer.remaining(@map.currentStat.penalty.seconds, @map.timeToDo)
		
		if timer.isNegative then
			@color = 'red'
			sign   = '- '
		elsif remaining <= 5 then
			@color = 'orange'
		else
			@color = 'black'
		end

		return sign + Timer.toTime(remaining)
	end

end
