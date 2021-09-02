extends Spatial

# Scenes
var _interactable_body = preload("res://Scenes/Interaction/InteractableBody.tscn")

# Resources
var _res_lib : MeshLibrary = preload("res://Data/MeshLibraries/Resources.meshlib")

# Nodes
onready var _grid = get_parent().get_node("TerrainGridMap")

func _ready():
	put_resource("rock_smallA", Vector3(0, 0, 0))

func put_resource(res_name, pos = Vector3(0, 0, 0)):
	# Find mesh by name
	var mesh = _res_lib.get_item_mesh(_res_lib.find_item_by_name(res_name))
	if not mesh:
		print("Mesh " + res_name + " could not be loaded from the Resources MeshLibrary.")
		return
	
	# Create an InteractableBody
	var body = _interactable_body.instance()
	body.build(_grid.get_tile_data_from_coords(pos), mesh, pos, res_name, "Resource")
	add_child(body)
	# Translate to position
	body.global_translate(pos * 2 + Vector3(1, 0, 1))
