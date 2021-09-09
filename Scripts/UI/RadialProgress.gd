extends TextureProgress

# Signals
signal started
signal ended
signal halted

# State
var in_progress = false

func _process(delta):
	if in_progress:
		var progress = 1 - ($Timer.time_left / $Timer.wait_time)
		value = progress * 100

func start():
	emit_signal("started")
	in_progress = true
	$Timer.start()

func stop():
	if in_progress:
		emit_signal("halted")
		in_progress = false
	value = 0
	$Timer.stop()

func _on_Timer_timeout():
	emit_signal("ended")
	in_progress = false
	value = 100
