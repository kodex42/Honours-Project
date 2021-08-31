extends StaticBody

# State
var _data = {
	"name" : "",
	"type" : "",
	"tile" : null
}

func build(occupying_tile : TileData, mesh : Mesh, pos : Vector3):
	# Set tile data
	self._data.tile = occupying_tile
	# Set the mesh to the mesh instance
	$MeshInstance.mesh = mesh
	$MeshInstance.create_trimesh_collision()
	# A static body with the collisionshape we need was created in the last line
	var s_body = $MeshInstance.get_child(0) # The mesh instance now has a StaticBody child
	var c_shape = s_body.get_child(0) # The StaticBody has the CollisionShape we need for the Area
	# Remove the StaticBody and copy the CollisionShape under the Area as its collision
	add_child(c_shape.duplicate())
	s_body.queue_free()
	# Scale to correct size
	global_scale(Vector3(2, 2, 2))

func get_data():
	return self._data
