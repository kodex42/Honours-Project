extends Node

# State
var twelve_hour = true
var period : String

func toggle_twelve_hour():
	twelve_hour = not twelve_hour

func get_clock_time():
	var biased_time = get_biased_time_in_seconds()
	var minutes = int(biased_time / 60) % 60
	var hours = int(biased_time / 3600) % 24
	var clock_time = "%02d:%02d"
	
	if twelve_hour:
		if hours > 12:
			hours -= 12
			period = "pm"
		else:
			period = "am"
	
	return clock_time % [hours, minutes]

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

func get_biased_time_in_seconds():
	return OS.get_system_time_secs() + get_time_zone_bias() * 60
