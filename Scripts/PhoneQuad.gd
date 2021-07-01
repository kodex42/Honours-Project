extends MeshInstance

func _ready():
	var mat = SpatialMaterial.new()
	mat.albedo_texture = owner.get_node("Phone/PhoneViewport").get_texture()
	mat.resource_local_to_scene = true
	mat.flags_transparent = true
	mat.flags_unshaded = true
	mesh.surface_set_material(0, mat)

