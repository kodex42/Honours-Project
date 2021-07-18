extends "res://Scripts/PhoneScreen.gd"

# Constants
const orbit_speed = PI/256

func _ready():
	pass

func _process(delta):
	$PromptOrbitPoint.rotate_x(orbit_speed)

func phone_up():
	print(name + ": Scroll messages up")

func phone_down():
	print(name + ": Scroll messages down")

func phone_right():
	$Objects/Message.swap_type()
