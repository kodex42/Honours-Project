extends Control

# State
var _interactable_object

func _process(delta):
	if Input.is_action_just_pressed("Selection 1") and _interactable_object:
		_interactable_object.interact()

# Data is structured as below for InteractableBody
#var _data = {
#	"name" : "",
#	"type" : "",
#	"tile" : null
#}
func show_interactable_info(obj):
	_interactable_object = obj
	var data = obj.get_data()
	$InteractableInfo.show()
	var label_cont = $InteractableInfo/MarginContainer/VBoxContainer
	label_cont.get_node("Name").set_text("Object: " + data.name)
	label_cont.get_node("Type").set_text("Type: " + data.type)
	label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")

func hide_interactable_info():
	_interactable_object = null
	$InteractableInfo.hide()
