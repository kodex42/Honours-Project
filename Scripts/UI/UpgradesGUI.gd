extends Control

# Exports
export(NodePath) onready var _gui = get_node(_gui)
export(NodePath) onready var _phone_gui = get_node(_phone_gui)

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close()

func create(tree_name):
	match tree_name:
		"Cash Upgrades":
			pass
		"Byte Upgrades":
			pass
	set_process(true)
	_gui.set_process(false)
	_phone_gui.phone.disable()
	GlobalControls.exclude()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

func close():
	set_process(false)
	_gui.set_process(true)
	_phone_gui.phone.enable()
	GlobalControls.unexclude()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
