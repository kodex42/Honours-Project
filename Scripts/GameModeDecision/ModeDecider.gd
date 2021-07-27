extends Node

# Exports
export(bool) var server_mode

func _ready():
	# Replace the current scene based on the game mode export variable
	if server_mode:
		change_scene("res://Scenes/Server.tscn")
	else:
		change_scene("res://Scenes/Main.tscn")
func change_scene(path):
	get_tree().change_scene(path)
