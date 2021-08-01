# Two state objects have only two states, and will have their active state
# loaded client side when a level is requested from the server.
# When a two state object is interacted with, it has its state flipped to
# the alternative state.
# Two state objects can only be interacted with once client side.

extends "res://Scripts/Levels/SpecialObjects/SpecialObject.gd"

func _ready():
	init("Two State Object", "This is a Two State Object, a Special Object with a binary state.")
	set_state(false)

# For user interaction
func _on_interaction():
	set_state(not state)

func _on_Button_button_pressed():
	interact()
