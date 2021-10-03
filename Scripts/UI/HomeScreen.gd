extends Control

# Signals
signal app_opened(app_name)

# Nodes
onready var _clock = $MarginContainer/VBoxContainer/HBoxContainer/Clock
onready var _seconds = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Seconds
onready var _period = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/Period

func _process(delta):
	update_clock()

func toggle_twelve_hour():
	Time.toggle_twelve_hour()
	update_clock()

func update_clock():
	var time = Time.get_clock_time()
	_clock.set_text(time.substr(0,5))
	_seconds.set_text(time.substr(6,8))
	if Time.twelve_hour:
		_period.show()
		_period.set_text(Time.get_period())
	else:
		_period.hide()

func _on_clock_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		toggle_twelve_hour()

func _on_MarginContainer_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		print("clicked!")

func _on_app_opened(app_name):
	if app_name == "QuitApp":
		GlobalControls.quit()
	elif "Machining" in app_name:
		print("Display Machining GUI for " + app_name)
	else:
		emit_signal("app_opened", app_name)
