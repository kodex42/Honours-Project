extends MarginContainer

# Exports
export(Array, NodePath) onready var backgrounds

# Nodes
onready var label = get_node("BackgroundVBox/CenterContainer/MarginContainer/Label")

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

func swap_type():
	set_type(MessageType.RECIEVED) if type == MessageType.SENT else set_type(MessageType.SENT)

func set_type(m_type : int):
	type = m_type
	if type == MessageType.SENT:
		self.size_flags_horizontal = SIZE_SHRINK_END
		set_background_color(Color(0.3, 0.3, 1))
		set_text_color(Color.white)
	if type == MessageType.RECIEVED:
		set_background_color(Color.lightcyan)
		set_text_color(Color.black)

func set_text(msg : String):
	label.set_text(msg)

func set_text_color(col : Color):
	label.set("custom_colors/font_color", col)

func set_background_color(col : Color):
	for b in backgrounds:
		get_node(b).modulate = col
