extends Node

# Dimension starts at 5 x 5
# From 0 -> 50
# +1 in width OR in height, with max of 30 for both
# From 30 -> 50
# -0.5 sec in time
# Then, nothing change, keep the pace

func get_level() -> Dictionary:
	# width: width of the maze
	# height: height of the maze
	# time: width of the maze
	# p: probability of being filled with a wall
	
	var width : int = Global.width
	var height : int = Global.height
	if Global.score == 0:
		width = 5
		height = 5
	elif Global.score <= 50:
		# p_m: probability of increasing the smaller
		# the more the difference between both increase the more p_m increase
		# p_m goes from 0.5 (both the same value) to 1, in a 1/x relation
		# .5 + (1 - 1 / (x + 1)) * .5 = (2x + 1) / (2(x + 1)) ; x = absolute difference
		var difference_w_h : int = width - height
		var abs_difference_w_h : float = abs(difference_w_h)
		var p_m : float = (2 * abs_difference_w_h + 1) / (2 * (abs_difference_w_h + 1))
		if difference_w_h > 0:
			if randf() < p_m:
				height += 1
			else:
				width += 1
		else:
			if randf() < p_m:
				width += 1
			else:
				height += 1
				
	# Find probablity of being filled (-emptyness level)
	var p : float = 0.4
	# Find time
	var time : float = Global.time_max
	if Global.score == 0:
		time = 20
	elif Global.score > 30:
		time -= 0.5
		
	return {
		"width": width,
		"height": height,
		"p": p,
		"time": time,
	}
