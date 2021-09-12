extends Node

func _ready():
	randomize()
	pass

func randb():
	return true if randi() % 2 == 0 else false
