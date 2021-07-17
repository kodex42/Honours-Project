extends "res://Scripts/PhoneScreen.gd"

func _ready():
	pass

func phone_up():
	print(name + ": Scroll messages up")

func phone_down():
	print(name + ": Scroll messages down")

func phone_right():
	$Objects/Message.swap_type()
