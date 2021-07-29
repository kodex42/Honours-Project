extends Control

# Preloads
var message_scene = preload("res://Scenes/Phone/Screens/Message.tscn")

# Nodes
onready var margin = $MarginContainer
onready var msg_cont = $MarginContainer/VBoxContainer

func _ready():
	new_message("I am a recieved message", 1)
	new_message("I am also a recieved message! aAAAAAAAAAAAAAAAAAAAAAAAAA", 1)
	new_message("I am a sent message...", 0)
	pass

func _process(delta):
	pass

func new_message(msg : String, type : int):
	var message = message_scene.instance()
	message.init(msg, type)
	# If another message exists, check its type
	if msg_cont.get_children().size() > 0:
		var last_message = msg_cont.get_child(msg_cont.get_children().size() - 1)
		# If the last message was a different type, add a seperator
		if message.type != last_message.type:
			var s = HSeparator.new()
			s.set("custom_constants/separation", 50)
			msg_cont.add_child(s)
	msg_cont.add_child(message)
