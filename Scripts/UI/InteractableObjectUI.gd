extends Control

# Signals
signal resource_count_changed(type, amount)

# Preloads
var resource_textures = {
	"wood" : preload("res://Data/Textures/Resources/wood.png"),
	"water" : preload("res://Data/Textures/Resources/water.png"),
	"coal" : preload("res://Data/Textures/Resources/coal.png"),
	"rock chunk" : preload("res://Data/Textures/Resources/rock_chunk.png"),
	"metal" : preload("res://Data/Textures/Resources/metal.png"),
	"cash" : preload("res://Data/Textures/Resources/cash.png"),
	"byte" : preload("res://Data/Textures/Resources/byte.png")
}

# Nodes
onready var gather_cont = $PanelContainer/HBoxContainer/CenterContainer
onready var label_cont = $PanelContainer/HBoxContainer/LeftContainer/VBoxContainer
onready var inv_cont = $PanelContainer/HBoxContainer/RightContainer/InventoryContainer
onready var rad_progresss = $PanelContainer/HBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/RadialProgress
onready var button = $PanelContainer/HBoxContainer/CenterContainer/HBoxContainer/VBoxContainer/Button

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
	update_inventory()

func update_inventory():
	var inventory = _interactable_object.get_inventory()
	var res = resource_textures[inventory.item_type]
	var icon = inv_cont.get_node("Button/ItemTypeIcon")
	icon.texture = res
	icon.modulate.a = 0.4 if inventory.amount == 0 else 1.0
	
	var label = icon.get_node("AmountLabel")
	label.set_text(str(inventory.amount))

func _on_Retrieve_Button_pressed():
	var gains = _interactable_object.remove_from_inventory(10)
	update_inventory()
	emit_signal("resource_count_changed", _interactable_object.get_inventory().item_type, gains)

func _on_Gather_Button_pressed():
	button.disabled = true
	rad_progresss.start()

func _on_RadialProgress_ended():
	button.disabled = false
	_interactable_object.interact()
	update_inventory()

func _on_RadialProgress_halted():
	button.disabled = false

func _on_InteractableObjectUI_visibility_changed():
	if not visible:
		rad_progresss.stop()
