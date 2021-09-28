extends Control

# Signals
signal app_opened(app_name)

# Preloads
var message_scene = preload("res://Scenes/Phone/Screens/Message.tscn")

# Exports
export(NodePath) onready var margin = get_node(margin)
export(NodePath) onready var scr_cont = get_node(scr_cont)
export(NodePath) onready var msg_cont = get_node(msg_cont)

func _process(delta):
	var rect = msg_cont.get("rect_size")
	var min_rect = msg_cont.get("rect_min_size")
	if rect.x != min_rect.x:
		msg_cont.set("rect_size", Vector2(min_rect.x, rect.y))

func new_message(msg : String, type : int):
	var message = message_scene.instance()
	message.init(msg, type)
	# If another message exists, check its type
	if msg_cont.get_children().size() > 0:
		var last_message = msg_cont.get_child(msg_cont.get_children().size() - 1)
		# If the last message was a different type, add a seperator
		if message.type != last_message.type:
			var s = HSeparator.new()
			s.modulate.a = 0
			s.set("custom_constants/separation", 5)
			msg_cont.add_child(s)
	add_message(message)
	yield(get_tree().create_timer(.1), "timeout")

func add_message(message):
	msg_cont.add_child(message)
	yield(get_tree(), "idle_frame")
	scr_cont.scroll_vertical = scr_cont.get_v_scrollbar().max_value

func _on_PhoneGUI_message_received(msg):
	new_message(msg, 1)

func _on_PhoneGUI_message_sent(msg):
	new_message(msg, 0)

func _on_BackButton_pressed():
	emit_signal("app_opened", "Home")
