extends "res://Scripts/Levels/Level.gd"

# Nodes
onready var resource_grid = get_node("ResourceGrid")

func _ready():
	resource_grid.generate_resources()
