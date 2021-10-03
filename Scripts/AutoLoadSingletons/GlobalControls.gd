extends Node

# Signals
signal prompt_quit()

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		quit()

func quit(are_you_sure = false):
	if are_you_sure:
		get_tree().quit()
	else:
		emit_signal("prompt_quit")
