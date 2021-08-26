extends Node

# Signals
signal controls_changed(control)

# State
var control = ""

func _ready():
	enable_pc()

func is_pc():
	return control == "PC"

func is_gamepad():
	return control == "Gamepad"

func set_control(c):
	control = c
	emit_signal("controls_changed", control)

func enable_pc():
	set_control("PC")

func enable_gamepad():
	set_control("Gamepad")
