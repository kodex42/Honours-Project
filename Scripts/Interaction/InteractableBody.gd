extends StaticBody

# Resources
var _res_lib : MeshLibrary = preload("res://Data/MeshLibraries/Resources.meshlib")

# State
var _data = {
	"name" : "",
	"type" : "",
	"tile" : null
}

func build(occupying_tile : TileData, pos : Vector3, body_name : String, body_type : String):
	# Set data
	self._data.name = body_name
	self._data.type = body_type
	self._data.tile = occupying_tile
	# A static body with the collisionshape we need was created in the last line
	var s_body = $MeshInstance.get_child(0) # The mesh instance now has a StaticBody child
	var c_shape = s_body.get_child(0) # The StaticBody has the CollisionShape we need for the Area
	# Remove the StaticBody and copy the CollisionShape under the Area as its collision
	add_child(c_shape.duplicate())
	s_body.queue_free()
	# Scale to correct size
	global_scale(Vector3(2, 2, 2))

func generate_mesh(mesh_name):
	# Find mesh by name
	var mesh = _res_lib.get_item_mesh(_res_lib.find_item_by_name(mesh_name))
	if not mesh:
		print("Mesh " + mesh_name + " could not be loaded from the Resources MeshLibrary.")
		return
	# Set the mesh to the mesh instance
	$MeshInstance.mesh = mesh
	$MeshInstance.create_trimesh_collision()

func interact():
	print("Interact")

func get_data():
	return self._data
