extends Node

# Signals
signal prompt_quit()
signal unprompt_quit()

# State
var excluded = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and not excluded:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			quit()
		else:
			unquit()

func exclude():
	excluded = true

func unexclude():
	excluded = false

func quit(are_you_sure = false):
	if are_you_sure:
		get_tree().quit()
	else:
		emit_signal("prompt_quit")

func unquit():
	emit_signal("unprompt_quit")
