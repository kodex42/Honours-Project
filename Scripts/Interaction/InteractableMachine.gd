extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export var body_name : String
export var produced_resource : int
export var machine_category : String

# Nodes
onready var _parent = get_parent()
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var on = false
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
var conveyer_in_range
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
	if body_name == "Conveyer":
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

func set_resources_in_range(resources):
	resources_in_range = resources

func set_conveyer_in_range(con):
	conveyer_in_range = con

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
	pass

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

func is_on():
	return on

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
	anim_seek(0)

func anim_seek(frame):
	_anim_player.seek(frame, true)

func on_animation_finished(anim_name):
	play_anim()
	if body_name == "Conveyer":
		set_conveyer_in_range(_parent.request_conveyer_in_range(self, grid_pos, facing_dir))
		if conveyer_in_range:
			conveyer_in_range.anim_seek(0)
			pass
