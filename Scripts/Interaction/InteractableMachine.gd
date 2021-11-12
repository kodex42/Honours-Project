extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export(NodePath) onready var payload_parent = get_node(payload_parent)
export(NodePath) onready var abandoned_node_parent = get_node(abandoned_node_parent)
export var body_name : String
export var produced_resource : int
export var machine_category : String
export var preview = false

# Nodes
onready var _parent = get_parent()
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var on = false
var power_network = null
var base_power_draw = 0
var wheel_speed = 0
var transfer_ready = false
var transfer_point = null
var transfering = false
var pulls_from_producer = false
var facing_dir
var grid_pos
var machine_stats
var accumulated_time = 0.0
var active_ingredients = {
		"wood": 0,
		"water": 0,
		"rock chunk": 0,
		"metal": 0,
		"coal": 0
}
var ingredients_required
var requires_ingredients = false
var resources_in_range = []
var anim

# Called when the node enters the scene tree for the first time.
func _ready():
	if not preview:
		# Ready animation
		anim = _anim_player.get_animation_list()[0]
		_anim_player.connect("animation_finished", self, "on_animation_finished")
		call_deferred("anim_seek", 0)
		
		# Apply state
		compute_stats()
		self._inventory.max = 1000000000000
		
		# Conditional
		if machine_category == "Moving":
			on = true
			match body_name:
				"Conveyer":
					play_anim()
					get_tree().call_group("Conveyer", "reset_anim")
				"Accumulator":
					play_anim()
		if machine_category == "Powering" and body_name != "Wheel":
			toggle()
		elif body_name == "Wheel":
			on = true
	else:
		set_collision_layer_bit(0, false)
		set_collision_layer_bit(1, false)
		set_collision_layer_bit(2, false)
		set_collision_mask_bit(0, false)

func _process(delta):
	if not preview:
		var tile = self._data.tile
		var power_draw = base_power_draw * machine_stats.Efficiency
		if on and tile.has_power(power_draw):
			if (machine_category == "Gathering" and resources_in_range.size() == 0) or (requires_ingredients and not all_ingredients_active()):
				set_anim_speed(0)
				return
			elif body_name == "Wheel":
				set_anim_speed(wheel_speed)
			else:
				set_anim_speed(machine_stats.Speed)
			accumulated_time += delta
			# Check if tick has passed
			var tick = 1.0 / machine_stats.Speed
			if accumulated_time >= tick:
				tile.extract_power(power_draw)
				accumulated_time -= tick
				# Contextual process based on machine type
				match machine_category:
					"Gathering":
						gather(delta)
					"Refining":
						refine(delta)
					"Powering":
						generate_power(delta)
				if body_name == "Inserter" and not transfering:
					move(delta)
		elif on:
			set_anim_speed(0)

func gather(delta):
	for r in resources_in_range:
		var amount = r.remove_from_stores(machine_stats.Power)
		if amount > 0:
			add_to_inventory(amount)

func refine(delta):
	if all_ingredients_active():
		for i in ingredients_required.keys():
			var val = ingredients_required[i]
			active_ingredients[i] -= val
		if body_name != "Market":
			add_to_inventory(machine_stats.Power)
		else:
			emit_signal("add_to_player_inventory", "cash", machine_stats.Power)
			emit_signal("inventory_updated")

func move(delta):
	var source_machine = _parent.request_machine_in_range(self, grid_pos, -facing_dir)
	if source_machine and source_machine.is_producer():
		if source_machine.has_items():
			var rType = source_machine.get_inventory().item_type
			var amount = source_machine.remove_from_inventory(10 * self.machine_stats.Power)
			var stack_instance = _parent.create_resource_stack(rType, amount)
			accept_payload(stack_instance)
		if not pulls_from_producer:
			pulls_from_producer = true

func generate_power(delta):
	if body_name == "Steam Engine" or body_name == "Reactor":
		if all_ingredients_active():
			for i in ingredients_required.keys():
				var val = ingredients_required[i]
				active_ingredients[i] -= val
			power_network.add_power(machine_stats.Power)
			emit_signal("inventory_updated")
	elif body_name == "Wheel" and wheel_speed > 0:
		power_network.add_power(machine_stats.Power * wheel_speed)
	entropy()

func set_resources_in_range(resources):
	resources_in_range = resources

func compute_stats():
	var stats = Constants.BASE_MACHINE_STATS.duplicate(true)
	var mods = GlobalMods.machine_stat_mods[body_name]
	for s in stats.keys():
		stats[s] *= mods[s]
	self.machine_stats = stats
	
	if Constants.MACHINE_INGREDIENTS[body_name]:
		ingredients_required = Constants.MACHINE_INGREDIENTS[body_name].duplicate(true)
		requires_ingredients = true
		if machine_category == "Refining":
			for k in ingredients_required.keys():
				ingredients_required[k] *= stats.Power
	base_power_draw = Constants.MACHINE_POWER_DRAW[body_name]

func create(tile, pos, parent):
	var resource
	match(produced_resource):
		ResourceType.WOOD:
			resource = "wood"
		ResourceType.WATER:
			resource = "water"
		ResourceType.COAL:
			resource = "coal"
		ResourceType.ROCK_CHUNK:
			resource = "rock chunk"
		ResourceType.METAL:
			resource = "metal"
		ResourceType.CASH:
			resource = "cash"
		ResourceType.BYTE:
			resource = "byte"
	self.build(tile, pos, body_name, "Machine", resource)
	tile.set_machine(self)
	compute_stats()
	if machine_category == "Powering":
		create_power_network(parent)

func create_power_network(parent = null, power = 0):
	if parent:
		var tiles_in_range = parent.request_tiles_in_radial_range(self, grid_pos, machine_stats.Range)
		power_network = PowerNetwork.new()
		power_network.create(tiles_in_range, self)
		if power > 0:
			power_network.add_power(power)
	else:
		create_power_network(_parent, power)

func spin(speed, is_idle):
	wheel_speed = speed/5 if not is_idle else 0
	set_anim_speed(wheel_speed)

func entropy():
	var tile = self._data.tile
	var ent : int
	match body_name:
		"Power Tower":
			ent = 1 * machine_stats.Efficiency
		"Steam Engine":
			ent = 5 * machine_stats.Efficiency
		"Reactor":
			ent = 50 * machine_stats.Efficiency
		"Wheel":
			ent = machine_stats.Power/2
	tile.extract_power(ent * machine_stats.Efficiency)

func board():
	reset_anim()
	set_anim_speed(0)
	play_anim()

func unboard():
	wheel_speed = 0
	reset_anim()
	stop_anim()

func transfer_payload(machine):
	transfering = false
	for payload in payload_parent.get_children():
		payload_parent.remove_child(payload)
		machine.accept_payload(payload, self)
	transfer_ready = false
	transfer_point = null

func accept_payload(payload : Node, from = null):
	if is_mover():
		transfering = true
		if payload_parent.get_child_count() == 0:
			if body_name == "Conveyer":
				payload.make_kinematic()
				payload.set_constant_velocity(facing_dir * machine_stats.Speed)
			else:
				payload.make_static()
				reset_anim()
				play_anim()
			payload_parent.add_child(payload)
			payload.reset_pos()
		else:
			var cur_payload = payload_parent.get_child(0)
			cur_payload.add_info(payload)
	else:
		if body_name == "Accumulator":
			var stack = payload.get_info()
			for k in stack.keys():
				stack[k] *= ceil(float(machine_stats.Power) / 2.0)
			add_to_player_inventory(stack)
		elif machine_category == "Refining" or body_name == "Steam Engine" or body_name == "Reactor":
			add_active_ingredient_stack(payload.get_info())
		payload.queue_free()

func abandon_payload():
	transfering = false
	if payload_parent.get_child_count() > 0:
		var payload = payload_parent.get_child(0)
		payload_parent.remove_child(payload)
		abandoned_node_parent.add_child(payload)
		payload.abandon()
		payload.apply_central_impulse(facing_dir + Vector3.UP)

func accepts_payloads():
	return (machine_category == "Moving" or machine_category == "Refining" or body_name == "Steam Engine" or body_name == "Reactor") and not pulls_from_producer

func dismantle():
	var costs = Constants.MACHINE_COSTS[body_name].duplicate(true)
	for i in costs.keys():
		costs[i] = Big.new(costs[i]).divide(2).roundDown()
	return costs

func has_items():
	return _inventory.amount > 0

func has_ingredients():
	return requires_ingredients

func all_ingredients_active():
	for i in ingredients_required.keys():
		var val = ingredients_required[i]
		if active_ingredients[i] < val:
			return false
	return true

func set_direction(dir):
	facing_dir = dir

func set_grid_pos(pos):
	grid_pos = pos

func get_direction():
	return facing_dir

func get_grid_pos():
	return grid_pos

func get_active_ingredients():
	return active_ingredients

func get_active_ingredient(res_name):
	return active_ingredients[res_name]

func get_required_ingredients():
	return ingredients_required

func get_required_ingredient(res_name):
	return ingredients_required[res_name]

func set_state(inventory, active_ingredients, power):
	self._inventory = inventory
	self.active_ingredients = active_ingredients
	if machine_category == "Powering" and power_network:
		power_network.add_power(power)

func add_active_ingredient(res_name, amount):
	active_ingredients[res_name] += amount
	emit_signal("inventory_updated")

func add_active_ingredient_stack(stack):
	for r in stack.keys():
		if ingredients_required.has(r):
			active_ingredients[r] += stack[r]
	emit_signal("inventory_updated")

func add_to_player_inventory(stack):
	for r in stack.keys():
		emit_signal("add_to_player_inventory", r, stack[r])

func is_on():
	return on

func is_mover():
	return machine_category == "Moving" and body_name != "Accumulator"

func is_producer():
	return machine_category == "Gathering" or (machine_category == "Refining" and body_name != "Market")

func get_production():
	return produced_resource

func toggle():
	on = not on
	update_anim()

func update_anim():
	if on:
		play_anim()
	else:
		stop_anim()

func interact():
	play_anim()

func play_anim():
	_anim_player.play(anim)

func stop_anim():
	_anim_player.stop()
	reset_anim()

func reset_anim():
	anim_seek(0)

func anim_seek(frame):
	if anim:
		_anim_player.seek(frame, true)

func set_anim_speed(speed):
	_anim_player.playback_speed = speed

func get_anim_speed():
	return _anim_player.playback_speed

func attempt_payload_transfer():
	var in_range = _parent.request_machine_in_range(self, grid_pos, facing_dir)
	if in_range and in_range.accepts_payloads():
		transfer_payload(in_range)
	else:
		abandon_payload()

func on_animation_finished(anim_name):
	if body_name == "Inserter" and payload_parent.get_child_count() > 0:
		attempt_payload_transfer()
	if body_name != "Inserter":
		play_anim()

func get_tiles_in_radial_range():
	return _parent.request_tiles_in_radial_range(self, global_transform.origin, machine_stats.Range)

func save():
	var save_data = .save()
	save_data["machine_name"] = self.body_name
	save_data["machine_category"] = self.machine_category
	save_data["facing_dir"] = {
		"x" : int(round(self.facing_dir.x)),
		"y" : int(round(self.facing_dir.y)),
		"z" : int(round(self.facing_dir.z))
	}
	save_data["on"] = self.on
	save_data["active_ingredients"] = self.active_ingredients
	save_data["power"] = self.power_network.get_divided_power() if self.machine_category == "Powering" else 0
	return save_data

func _on_ConveyerEndArea_body_entered(body):
	if payload_parent.get_child_count() > 0 and body == payload_parent.get_child(0):
		attempt_payload_transfer()

func _on_Machine_tree_exited():
	if machine_category == "Powering" and power_network != null:
		power_network.recalculate(self)
