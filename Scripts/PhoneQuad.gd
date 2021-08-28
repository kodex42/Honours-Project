extends MeshInstance

func _ready():
	if Server.ignore_server:
		_on_server_connected()
	else:
		Server.connect("connected", self, "_on_server_connected")

func _on_server_connected():
	var tex := owner.get_node("PhoneViewport").get_texture() as ViewportTexture
	tex.set_flags(4)
	var mat = SpatialMaterial.new()
	mat.set("albedo_texture", tex)
#	mat.set("resource_local_to_scene", true)
	mat.set("flags_transparent", true)
	mat.set("flags_unshaded", true)
	mat.set("flags_no_depth_test", true)
	mat.set("flags_albedo_tex_force_srgb", true)
	mesh.surface_set_material(0, mat)
	get_parent().call_deferred("remove_child", get_parent().get_node("LoadingScreenViewport"))
