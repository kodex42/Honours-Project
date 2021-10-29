extends Control

# Signals
signal resource_count_changed(type, amount)
signal attempt_add_ingredient(res, amount, machine)
signal machine_dismantled(refund)
signal wheel_boarded(wheel)

# Preloads
var ingredient_scene = preload("res://Scenes/UI/Ingredient.tscn")
var resource_textures = Constants.RESOURCE_ICONS

# Exports
export(NodePath) onready var label_cont = get_node(label_cont)
export(NodePath) onready var rad_progress = get_node(rad_progress)
export(NodePath) onready var gather_button = get_node(gather_button)
export(NodePath) onready var inv_cont = get_node(inv_cont)
export(NodePath) onready var power_icon_cont = get_node(power_icon_cont)
export(NodePath) onready var retrieve_button = get_node(retrieve_button)
export(NodePath) onready var power_button = get_node(power_button)
export(NodePath) onready var ingredient_cont = get_node(ingredient_cont)
export(NodePath) onready var dismantle_button = get_node(dismantle_button)
export(NodePath) onready var add_all_ingredients_btn = get_node(add_all_ingredients_btn)
export(NodePath) onready var status_container = get_node(status_container)
export(NodePath) onready var board_button_cont = get_node(board_button_cont)

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

func _process(delta):
	if self._type == "Machine":
		update_status()

func build_from_interactable_object(obj):
	inv_cont.show()
	power_icon_cont.show()
	
	_interactable_object = obj
	var data = obj.get_data()
	label_cont.get_node("Name").set_text(data.name)
	label_cont.get_node("Type").set_text(data.type)
	label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")
	
	self._type = data.type
	if self._type == "Machine":
		update_power_button()
		display_ingredients()
		if _interactable_object.body_name == "Market" or _interactable_object.machine_category == "Powering":
			inv_cont.hide()
		else:
			inv_cont.show()
		if _interactable_object.body_name == "Wheel":
			board_button_cont.show()
		else:
			board_button_cont.hide()
	else:
		var stores = obj.get_stores()
		rad_progress.set_timer_mod(stores.manual_gather_rate)
	
	update_inventory()
	update_status()
	yield(get_tree().create_timer(.1), "timeout")

func update_inventory():
	var inventory = _interactable_object.get_inventory()
	var res = resource_textures[inventory.item_type]
	var icon = retrieve_button.get_node("ItemTypeIcon")
	icon.texture = res
	icon.modulate.a = 0.4 if inventory.amount == 0 else 1.0
	
	var label = icon.get_node("AmountLabel")
	label.set_text(str(inventory.amount))
	
	if self._type == "Machine":
		if _interactable_object.has_ingredients():
			for n in ingredient_cont.get_children():
				n.update()
		elif _interactable_object.body_name == "Conveyer" or _interactable_object.body_name == "Accumulator":
			inv_cont.hide()
			power_icon_cont.hide()
		else:
			for n in ingredient_cont.get_children():
				n.queue_free()

func update_status():
	if _interactable_object.machine_category != "Powering":
		status_container.show()
		var power_tex = status_container.get_node("TextureRect")
		var power_usage = _interactable_object.base_power_draw * _interactable_object.machine_stats.Efficiency
		if power_usage == 0:
			power_tex.modulate = Color.gray
		else:
			var tile = _interactable_object.get_data().tile
			if tile.has_power(power_usage):
				power_tex.modulate = Color.green
			else:
				power_tex.modulate = Color.red
	else:
		status_container.hide()

func update_power_button():
	_powered = _interactable_object.is_on()
	power_button.set("pressed", _powered)
	set_power_button_colour(Color(0.025, 0.8, 0.1) if _powered else Color(0.5, 0.5, 0.5))

func display_ingredients():
	for c in ingredient_cont.get_children():
		ingredient_cont.remove_child(c)
	if _interactable_object.has_ingredients():
		var ingredients = _interactable_object.get_required_ingredients()
		for i in ingredients.keys():
			var n = ingredient_scene.instance()
			n.build(_interactable_object, i, _interactable_object.get_required_ingredient(i))
			n.connect("attempt_add_active_ingredient", self, "on_attempted_add_active_ingredient")
			ingredient_cont.add_child(n)
	if ingredient_cont.get_child_count() > 0:
		add_all_ingredients_btn.show()
	else:
		add_all_ingredients_btn.hide()

func set_power_button_colour(c : Color):
	var img = power_button.get_node("PowerIcon")
	img.modulate = c

func deactivate():
	if _interactable_object:
		_interactable_object.disconnect("inventory_updated", self, "update_inventory")
	hide()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate():
	if _interactable_object:
		_interactable_object.connect("inventory_updated", self, "update_inventory")
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)

func on_attempted_add_active_ingredient(res, amount):
	emit_signal("attempt_add_ingredient", res, amount, _interactable_object)

func _on_Retrieve_Button_pressed():
	var gains
	if Input.is_action_pressed("sprint"):
		gains = _interactable_object.remove_from_inventory(50)
	else:
		gains = _interactable_object.remove_all_from_inventory()
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

func _on_Dismantle_Button_pressed():
	var refund = _interactable_object.dismantle()
	_interactable_object.get_data().tile.remove_machine()
	_interactable_object.queue_free()
	dismantle_button.set_pressed(false)
	emit_signal("machine_dismantled", refund)

func _on_AddAllIngredientsButton_pressed():
	for i in ingredient_cont.get_children():
		i.add_ingredients()

func _on_BoardingButton_pressed():
	board_button_cont.get_node("Button").set_pressed(false)
	if _interactable_object.body_name == "Wheel":
		emit_signal("wheel_boarded", _interactable_object)
