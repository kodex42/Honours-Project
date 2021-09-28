extends Node

# Signals
signal prompt_quit()

func quit(are_you_sure = false):
	if are_you_sure:
		get_tree().quit()
	else:
		emit_signal("prompt_quit")
