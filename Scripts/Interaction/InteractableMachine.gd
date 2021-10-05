extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export var body_name : String
export var produced_resource : int
export var machine_category : String

# Nodes
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var powered = false
var facing_dir
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

# Called when the node enters the scene tree for the first time.
func _ready():
	var anim = _anim_player.get_animation_list()[0]
	_anim_player.get_animation(anim).set_loop(true)
	machine_stats = Constants.BASE_MACHINE_STATS
	ingredients_required = Constants.MACHINE_INGREDIENTS[body_name]
	if ingredients_required:
		requires_ingredients = true

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
	if powered:
		accumulated_time += delta
		match machine_category:
			"Gathering":
				gather(delta)
			"Refining":
				refine(delta)

func set_resources_in_range(resources):
	resources_in_range = resources

func gather(delta):
	# Check if tick has passed
	var tick = 1.0 / machine_stats.Speed
	if accumulated_time >= tick:
		accumulated_time -= tick
		for r in resources_in_range:
			add_to_inventory(r.remove_from_stores(machine_stats.Power))
#		print("Gathering!")

func refine(delta):
	# Check if tick has passed
	var tick = 1.0 / machine_stats.Speed
	if accumulated_time >= tick:
		accumulated_time -= tick
		if all_ingredients_active():
			for i in ingredients_required.keys():
				var val = ingredients_required[i]
				active_ingredients[i] -= val
			add_to_inventory(machine_stats.Power)

func has_ingredients():
	return requires_ingredients

func all_ingredients_active():
	for i in ingredients_required.keys():
		var val = ingredients_required[i]
		if active_ingredients[i] < val:
			return false
	return true

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
	return powered

func get_production():
	return produced_resource

func toggle():
	powered = not powered
	update_anim()

func update_anim():
	var anim = _anim_player.get_animation_list()[0]
	if powered:
		_anim_player.play(anim)
	else:
		_anim_player.stop()
		_anim_player.seek(0, true)

func interact():
	var anim = _anim_player.get_animation_list()[0]
	_anim_player.play(anim)
