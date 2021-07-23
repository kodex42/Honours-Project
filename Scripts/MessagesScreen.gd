extends "res://Scripts/PhoneScreen.gd"

# Nodes
onready var message_collection = get_node("MessageCollectionViewport/MessageCollection")

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

func _on_Phone_message_sent(msg):
	message_collection.new_message(msg, 0)

func _on_Phone_message_received(msg):
	message_collection.new_message(msg, 1)
