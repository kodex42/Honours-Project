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

func _ready():
	put_resource(ResourceType.ROCK_CHUNK, Vector3(0, 0, 0))

func put_resource(type : int, pos = Vector3(0, 0, 0)):
	# Get tile data
	var tile = _grid.get_tile_data_from_coords(pos)
	# Create an InteractableResource
	var body = _interactable_resource.instance()
	body.create(type, pos, tile)
	add_child(body)
	# Translate to position
	body.global_translate(pos * 2 + Vector3(1, 0, 1))
