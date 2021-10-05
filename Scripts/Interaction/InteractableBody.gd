extends StaticBody

# Signal
signal inventory_updated()

# Resources
var _res_lib : MeshLibrary = preload("res://Data/MeshLibraries/Resources.meshlib")

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
	METAL,
	CASH,
	BYTE
}

# State
var _inventory = {
	"item_type" : "",
	"amount" : 0,
	"max" : 999
}
var _data = {
	"name" : "",
	"type" : "",
	"tile" : null
}

func build(occupying_tile : TileData, pos : Vector3, body_name : String, body_type : String, inventory_type : String):
	# Set data
	self._data.name = body_name
	self._data.type = body_type
	self._data.tile = occupying_tile
	self._inventory.item_type = inventory_type
	if body_type == "Resource":
		# Assume resources generate their own meshes and collision procedurally
		var s_body = $MeshInstance.get_child(0) # The mesh instance now has a StaticBody child
		var c_shape = s_body.get_child(0) # The StaticBody has the CollisionShape we need for the Area
		# Remove the StaticBody and copy the CollisionShape under the Area as its collision
		add_child(c_shape.duplicate())
		s_body.queue_free()
		# Scale to correct size
		set_deferred("scale", Vector3(2, 2, 2))
	else:
		# Scale to correct size
		set_deferred("scale", Vector3(1.2, 1.2, 1.2))

func generate_mesh(mesh_name):
	# Find mesh by name
	var mesh = _res_lib.get_item_mesh(_res_lib.find_item_by_name(mesh_name))
	if not mesh:
		print("Mesh " + mesh_name + " could not be loaded from the Resources MeshLibrary.")
		return
	# Set the mesh to the mesh instance
	$MeshInstance.mesh = mesh
	$MeshInstance.create_trimesh_collision()

func replace_mesh(mesh_name):
	if $MeshInstance.get_child_count() > 0:
		$MeshInstance.get_child(0).queue_free()
	generate_mesh(mesh_name)

func add_to_inventory(amount):
	self._inventory.amount = clamp(self._inventory.amount + amount, 0, self._inventory.max)
	emit_signal("inventory_updated")

func remove_from_inventory(amount):
	var val
	if self._inventory.amount < amount:
		val = self._inventory.amount
		self._inventory.amount = 0
	else:
		val = amount
		self._inventory.amount -= amount
	return val
	emit_signal("inventory_updated")

func get_data():
	return self._data

func get_inventory():
	return self._inventory

func interact():
	print("I am an interactable body!")
