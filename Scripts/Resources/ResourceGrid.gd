extends Spatial

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
}

# Scenes
var _interactable_resource = preload("res://Scenes/Interaction/InteractableResource.tscn")

# Nodes
onready var _grid = get_parent().get_node("TerrainGridMap")
onready var _floor = get_parent().get_node("StaticObjects/Floor")

func generate_resources():
#	var lim = _grid.GRID_SIZE
	put_resource(ResourceType.WOOD, Vector3(24, 0, 24))
	put_resource(ResourceType.WATER, Vector3(25, 0, 24))
	put_resource(ResourceType.COAL, Vector3(25, 0, 25))
	put_resource(ResourceType.ROCK_CHUNK, Vector3(24, 0, 25))

func put_resource(type : int, pos = Vector3(0, 0, 0)):
	var lim = _grid.GRID_SIZE
	# Get tile data
	var tile = _grid.get_tile_data_from_coords(pos)
	# Create an InteractableResource
	var body = _interactable_resource.instance()
	body.create(type, pos, tile)
	add_child(body)
	# Translate to position
	var global_pos = pos * 2 + Vector3(1, 0, 1) - Vector3(lim, 0, lim)
	body.global_translate(global_pos)
	# Use CSGBox to prevent clipping between floor and water tiles
	if type == ResourceType.WATER:
		var box = CSGBox.new()
		box.global_translate(global_pos)
		box.operation = CSGShape.OPERATION_SUBTRACTION
		_floor.get_node("CSGCombiner").add_child(box)
