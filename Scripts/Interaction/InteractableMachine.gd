extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export(NodePath) onready var payload_parent = get_node(payload_parent)
export(NodePath) onready var abandoned_node_parent = get_node(abandoned_node_parent)
export var body_name : String
export var produced_resource : int
export var machine_category : String

# Nodes
onready var _parent = get_parent()
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var on = false
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
	# Ready animation
	anim = _anim_player.get_animation_list()[0]
	_anim_player.connect("animation_finished", self, "on_animation_finished")
	
	# Apply state
	machine_stats = Constants.BASE_MACHINE_STATS
	ingredients_required = Constants.MACHINE_INGREDIENTS[body_name]
	if ingredients_required:
		requires_ingredients = true
	
	# Conditional
	if machine_category == "Moving":
		on = true
		match body_name:
			"Conveyer":
				play_anim()
				get_tree().call_group("Conveyer", "reset_anim")
			"Inserter":
				move(0)
			"Accumulator":
				play_anim()

func create(tile, pos):
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

func _process(delta):
	if on:
		accumulated_time += delta
		# Check if tick has passed
		var tick = 1.0 / machine_stats.Speed
		if accumulated_time >= tick:
			accumulated_time -= tick
			# Contextual process based on machine type
			match machine_category:
				"Gathering":
					gather(delta)
				"Refining":
					refine(delta)
			if body_name == "Inserter" and not transfering:
				move(delta)

func set_resources_in_range(resources):
	resources_in_range = resources

func gather(delta):
	for r in resources_in_range:
		add_to_inventory(r.remove_from_stores(machine_stats.Power))

func refine(delta):
	if all_ingredients_active():
		for i in ingredients_required.keys():
			var val = ingredients_required[i]
			active_ingredients[i] -= val
		add_to_inventory(machine_stats.Power)

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
				payload.set_constant_velocity(facing_dir * machine_stats.Power)
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
			add_to_player_inventory(payload.get_info())
		elif machine_category == "Refining":
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
	return (machine_category == "Moving" or machine_category == "Refining") and not pulls_from_producer

func dismantle():
	var costs = Constants.MACHINE_COSTS[body_name].duplicate(true)
	for i in costs.keys():
		costs[i] = costs[i] / 2
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

func add_active_ingredient(res_name):
	active_ingredients[res_name] += 1
	emit_signal("inventory_updated")

func add_active_ingredient_stack(stack):
	for r in stack.keys():
		if requires_ingredients.has(r):
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
	_anim_player.seek(frame, false)

func attempt_payload_transfer():
	var in_range = _parent.request_machine_in_range(self, grid_pos, facing_dir)
	if in_range and in_range.accepts_payloads():
		transfer_payload(in_range)
	else:
		abandon_payload()

func on_animation_finished(anim_name):
	if body_name == "Inserter" and payload_parent.get_child_count() > 0:
		attempt_payload_transfer()
	if body_name != "Wheel" and body_name != "Inserter":
		play_anim()

func _on_ConveyerEndArea_body_entered(body):
	if payload_parent.get_child_count() > 0 and body == payload_parent.get_child(0):
		attempt_payload_transfer()
