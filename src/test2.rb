a = Thread.new { 
	while true 
		print "B"
		sleep 2
	end 
}
i=0
while i <= 5 
	print "A"+i.to_s
	sleep 1.5
	i++
	if i==5 then
		a.join
	end
end