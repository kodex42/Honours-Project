extends Control

# Nodes
export(NodePath) onready var _clock = get_node(_clock)
export(NodePath) onready var _period = get_node(_period)

func _ready():
	_period.visible = Time.twelve_hour
	update_clock()
	$Timer.start()

func toggle_twelve_hour():
	Time.toggle_twelve_hour()
	update_clock()

func update_clock():
	_clock.set_text(Time.get_clock_time())
	if Time.twelve_hour:
		_period.show()
		_period.set_text(Time.get_period())
	else:
		_period.hide()

func _on_clock_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		toggle_twelve_hour()

func _on_Timer_timeout():
	update_clock()
	$Timer.start()
