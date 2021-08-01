# Multi-state objects have more than two states, and will have their active
# state loaded client side when a level is requested from the server.
# When a multi-state object is interacted with, it has its state changed to
# the next state in order denoted by an integer.
# Multi-state objects can only be interacted with once client side.

extends "res://Scripts/Levels/SpecialObjects/SpecialObject.gd"

# State
var max_state : int

func _ready():
	init("Multi-State Object", "This is a Multi-State Object, a Special Object with a set amount of states greater than two and that cycles its state on interaction.")
	set_state(0)
	set_max_state(3)

# Setters
func set_max_state(m):
	max_state = m

# Getters
func get_max_state():
	return max_state

# For user interaction
func _on_interaction():
	advance_state()

func advance_state():
	set_state(state + 1)
	if state > max_state:
		set_state(0)
