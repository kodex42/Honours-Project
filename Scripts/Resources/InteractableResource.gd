extends "res://Scripts/Interaction/InteractableBody.gd"

# Constants
const letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]

# State
var _type : int
var _stores = {
	"amount" : 100,
	"max" : 100,
	"recharge_progress" : 0.5,
	"recharge_rate" : 0.5,
	"manual_gather_rate" : 1
}

func _process(delta):
	_stores.recharge_progress -= delta
	if _stores.recharge_progress <= 0:
		_stores.recharge_progress = _stores.recharge_rate
		add_to_stores(1)

func create(type : int, pos : Vector3, tile : TileData):
	_type = type
	var body_name = "resource" 
	var resource : String
	match _type:
		ResourceType.WOOD:
			body_name = "Tree"
			resource = "wood"
			_stores.manual_gather_rate = 1
			generate_mesh("tree" + letters[randi() % 7])
		ResourceType.WATER:
			body_name = "Water"
			resource = "water"
			_stores.manual_gather_rate = 0
			generate_mesh("ground_riverTile")
			set_collision_layer_bit(2, false)
		ResourceType.COAL:
			body_name = "Sooty Rock"
			resource = "coal"
			_stores.manual_gather_rate = 0.2
			generate_mesh("coal_stone_tall" + letters[randi() % 9])
		ResourceType.ROCK_CHUNK:
			body_name = "Shiny Rock"
			resource = "rock chunk"
			_stores.manual_gather_rate = 0.25
			generate_mesh("stone_tall" + letters[randi() % 9])
	build(tile, pos, body_name, "Resource", resource)
	tile.set_resource(self)

func interact():
	add_to_inventory(gather_from_stores())

func add_to_stores(amount):
	self._stores.amount = clamp(self._stores.amount + amount, 0, self._stores.max)
	emit_signal("inventory_updated")

func remove_from_stores(amount):
	var val
	if self._stores.amount < amount:
		val = self._stores.amount
		self._stores.amount = 0
	else:
		val = amount
		self._stores.amount -= amount
	return val
	emit_signal("inventory_updated")

func gather_from_stores():
	return remove_from_stores(1)

func get_stores():
	return _stores

func get_type():
	return _type

func save():
	var save_data = .save()
	save_data["resource_type"] = self._type
	save_data["stores"] = self._stores
	return save_data
