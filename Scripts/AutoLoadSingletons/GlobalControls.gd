extends Node

# Global State
var exit_captured = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and not exit_captured:
		get_tree().quit()
