extends MarginContainer

# Exports
export(NodePath) onready var label = get_node(label)

# Enums
enum MessageType {
	SENT,
	RECIEVED
}

# State
var type : int

func _ready():
	set_type(MessageType.SENT)

func swap_type():
	set_type(MessageType.RECIEVED) if type == MessageType.SENT else set_type(MessageType.SENT)

func set_type(m_type : int):
	type = m_type
#	update_message()

func set_text(msg : String):
	label.set_text(msg)

#func update_message():
#	if type == MessageType.SENT:
#		$Background.modulate = Color(0.3, 0.3, 1)
#		$Text.modulate = Color.white
#		self.translation.x = 0.25
#	if type == MessageType.RECIEVED:
#		$Background.modulate = Color.lightcyan
#		$Text.modulate = Color.black
#		self.translation.x = -0.25
