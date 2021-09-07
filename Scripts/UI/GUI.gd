extends Control

# Nodes
onready var int_info = $InteractableInfo
onready var int_ui = $InteractableObjectUI

# State
var _interactable_object

func _process(delta):
	if Input.is_action_just_pressed("Selection 1") and _interactable_object and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		show_interactable_ui()
	if int_ui.visible:
		if Input.is_action_just_pressed("ui_cancel"):
			hide_interactable_ui()

func update_trackables(wood : Big, water : Big, coal : Big, rock_chunks : Big, metal : Big, cash : Big, bytes : Big):
	var trackables_cont = $ResourcesAndCurrencies/MarginContainer/VBoxContainer
	trackables_cont.get_node("Wood/Label").set_text(wood.toString())
	trackables_cont.get_node("Water/Label").set_text(water.toString())
	trackables_cont.get_node("Coal/Label").set_text(coal.toString())
	trackables_cont.get_node("RockChunks/Label").set_text(rock_chunks.toString())
	trackables_cont.get_node("Metal/Label").set_text(metal.toString())
	trackables_cont.get_node("Cash/Label").set_text(cash.toString())
	trackables_cont.get_node("Bytes/Label").set_text(bytes.toString())

# Data is structured as below for InteractableBody
#var _data = {
#	"name" : "",
#	"type" : "",
#	"tile" : null
#}
func show_interactable_info(obj):
	_interactable_object = obj
	var data = obj.get_data()
	var label_cont = $InteractableInfo/MarginContainer/VBoxContainer
	label_cont.get_node("Name").set_text("Object: " + data.name)
	label_cont.get_node("Type").set_text("Type: " + data.type)
	label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")
	int_info.show()

func show_interactable_ui():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	int_ui.build_from_interactable_object(_interactable_object)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer/QuitLabel.set_text("Close")
	GlobalControls.exit_captured = true
	int_ui.show()
	hide_interactable_info()

func hide_interactable_info():
	_interactable_object = null
	int_info.hide()

func hide_interactable_ui():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer/QuitLabel.set_text("Quit")
	GlobalControls.exit_captured = false
	int_ui.hide()
