extends Node

# State
var twelve_hour = true
var period : String
var anim_tick_rate = 2.0

func toggle_twelve_hour():
	twelve_hour = not twelve_hour

func get_clock_time():
	var time = OS.get_time()
	var hours = time.hour
	var minutes = time.minute
	var seconds = time.second
	var clock_time = "%02d:%02d:%02d"
	
	if twelve_hour:
		if hours > 12:
			hours -= 12
			period = "pm"
		else:
			period = "am"
	
	return clock_time % [hours, minutes, seconds]

func get_time_zone_bias():
	var result = OS.get_time_zone_info()
	if OS.get_name() == "Windows":
		var output = []
		OS.execute('WMIC.exe', ["OS","Get","CurrentTimeZone"],true, output)
		var bias = int(output[0].split("\n")[1])
		result.bias = bias
	return result.bias

func get_period():
	return period
