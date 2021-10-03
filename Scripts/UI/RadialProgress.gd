extends TextureProgress

# Signals
signal started
signal ended
signal halted

# Constants
const TIMER_WAIT_TIME = 1

# State
var in_progress = false
var timer_mod = 1

func _process(delta):
	if in_progress:
		var progress = 1 - ($Timer.time_left / $Timer.wait_time)
		value = progress * 100

func start():
	if timer_mod == 0:
		print("Could not progress")
		return
	emit_signal("started")
	in_progress = true
	$Timer.wait_time = TIMER_WAIT_TIME / timer_mod
	$Timer.start()

func stop():
	if in_progress:
		emit_signal("halted")
		in_progress = false
	value = 0
	$Timer.stop()

func set_timer_mod(val):
	timer_mod = val

func _on_Timer_timeout():
	emit_signal("ended")
	in_progress = false
	value = 100
