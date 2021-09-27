extends MarginContainer

# Exports
export(Array, NodePath) onready var backgrounds
export(NodePath) onready var label = get_node(label)
export(NodePath) onready var vbox = get_node(vbox)
export(NodePath) onready var r_cont = get_node(r_cont)
export(NodePath) onready var s_cont = get_node(s_cont)

# Enums
enum MessageType {
	SENT,
	RECIEVED
}

# State
var msg : String
var type : int

# Fake constructor
func init(m : String, t : int):
	self.msg = m
	self.type = t

func _ready():
	set_text(msg)
	set_type(type)

func _clips_input():
	return true

func swap_type():
	set_type(MessageType.RECIEVED) if type == MessageType.SENT else set_type(MessageType.SENT)

func set_type(m_type : int):
	type = m_type
	var cont
	if type == MessageType.SENT:
		set_text_color(Color.white)
		cont = s_cont
	if type == MessageType.RECIEVED:
		set_text_color(Color.black)
		cont = r_cont
	remove_child(vbox)
	cont.add_child(vbox)
	cont.show()
func set_text(msg : String):
	label.set_text(msg)

func set_text_color(col : Color):
	label.set("custom_colors/font_color", col)

func set_background_color(col : Color):
	for b in backgrounds:
		get_node(b).modulate = col
