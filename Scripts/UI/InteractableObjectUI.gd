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

# Exports
export(NodePath) onready var label_cont = get_node(label_cont)
export(NodePath) onready var rad_progress = get_node(rad_progress)
export(NodePath) onready var gather_button = get_node(gather_button)
export(NodePath) onready var retrieve_button = get_node(retrieve_button)
export(NodePath) onready var power_button = get_node(power_button)

# State
var _interactable_object = null
var _type = ""
var _powered = false

# Data is structured as below for InteractableBody
#var _data = {
#	"name" : "",
#	"type" : "",
#	"tile" : null
#}
func build_from_interactable_object(obj):
	_interactable_object = obj
	var data = obj.get_data()
	var stores = obj.get_stores()
	label_cont.get_node("Name").set_text(data.name)
	label_cont.get_node("Type").set_text(data.type)
	label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")
	rad_progress.set_timer_mod(stores.manual_gather_rate)
	update_inventory()
	
	self._type = data.type
	if self._type == "Machine":
		update_power_button()

func update_inventory():
	var inventory = _interactable_object.get_inventory()
	var res = resource_textures[inventory.item_type]
	var icon = retrieve_button.get_node("ItemTypeIcon")
	icon.texture = res
	icon.modulate.a = 0.4 if inventory.amount == 0 else 1.0
	
	var label = icon.get_node("AmountLabel")
	label.set_text(str(inventory.amount))

func update_power_button():
	_powered = _interactable_object.is_on()
	power_button.set("pressed", _powered)
	set_power_button_colour(Color(0.025, 0.8, 0.1) if _powered else Color(0.5, 0.5, 0.5))

func set_power_button_colour(c : Color):
	var img = power_button.get_node("PowerIcon")
	img.modulate = c

func deactivate():
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)

func _on_Retrieve_Button_pressed():
	var gains = _interactable_object.remove_from_inventory(10)
	update_inventory()
	emit_signal("resource_count_changed", _interactable_object.get_inventory().item_type, gains)

func _on_Gather_Button_pressed():
	gather_button.disabled = true
	rad_progress.start()

func _on_RadialProgress_ended():
	gather_button.disabled = false
	_interactable_object.interact()
	update_inventory()

func _on_RadialProgress_halted():
	gather_button.disabled = false

func _on_InteractableResource_visibility_changed():
	if not visible:
		rad_progress.stop()

func _on_Power_Button_pressed():
	_interactable_object.toggle()
	update_power_button()
