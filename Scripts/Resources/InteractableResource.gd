extends "res://Scripts/Interaction/InteractableBody.gd"

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
}

# Constants
const letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]

# State
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

func add_to_stores(amount):
	self._stores.amount = clamp(self._stores.amount + amount, 0, self._stores.max)

func remove_from_stores(amount):
	var val
	if self._stores.amount < amount:
		val = self._stores.amount
		self._stores.amount = 0
	else:
		val = amount
		self._stores.amount -= amount
	return val

func gather_from_stores():
	return remove_from_stores(_stores.manual_gather_rate)

func create(type : int, pos : Vector3, tile : TileData):
	var body_name = "resource" 
	var resource : String
	match type:
		ResourceType.WOOD:
			body_name = "Tree"
			resource = "wood"
			generate_mesh("tree" + letters[randi() % 7])
		ResourceType.WATER:
			# NEED TO FIX LATER
			body_name = "Tree"
			resource = "water"
			generate_mesh("tree" + letters[randi() % 7])
		ResourceType.COAL:
			body_name = "Sooty Rock"
			resource = "coal"
			generate_mesh("stone_tall" + letters[randi() % 9])
		ResourceType.ROCK_CHUNK:
			body_name = "Shiny Rock"
			resource = "rock chunk"
			generate_mesh("stone_tall" + letters[randi() % 9])
	build(tile, pos, body_name, "Resource", resource)

func interact():
	add_to_inventory(gather_from_stores())
