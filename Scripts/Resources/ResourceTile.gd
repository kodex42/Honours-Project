extends Node

var _timer = null

func _ready():
	_timer = Timer.new()
	add_child(_timer)
	
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.wait_time = 3.0
	_timer.one_shot = false
	_timer.start()

func _on_Timer_timeout():
	print("I am a Resource Tile!")
