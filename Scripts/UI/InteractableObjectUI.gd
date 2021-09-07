extends Control

# Nodes
onready var rad_progresss = $PanelContainer/HBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/RadialProgress
onready var button = $PanelContainer/HBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/Button
onready var label_cont = $PanelContainer/HBoxContainer/LeftContainer/VBoxContainer

# State
var _interactable_object = null

# Data is structured as below for InteractableBody
#var _data = {
#	"name" : "",
#	"type" : "",
#	"tile" : null
#}
func build_from_interactable_object(obj):
	_interactable_object = obj
	var data = obj.get_data()
	label_cont.get_node("Name").set_text(data.name)
	label_cont.get_node("Type").set_text(data.type)
	label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")

func _on_Button_pressed():
	button.disabled = true
	rad_progresss.start()

func _on_RadialProgress_ended():
	button.disabled = false
	_interactable_object.interact()
