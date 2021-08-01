extends MeshInstance

# Exports
export(bool) var on

# State
var surface_on : SpatialMaterial
var surface_off : SpatialMaterial

func _ready():
	surface_off = mesh.surface_get_material(0).duplicate()
	surface_off.set("emission_enabled", false)
	surface_off.set("emission", Color.black)
	surface_on = mesh.surface_get_material(0).duplicate()
	surface_on.set("emission_enabled", true)
	surface_on.set("emission", surface_on.get("albedo_color"))
	update_surface()

func update_surface():
	if not on:
		mesh.surface_set_material(0, surface_off)
		$OmniLight.hide()
	else:
		mesh.surface_set_material(0, surface_on)
		$OmniLight.show()

func _on_Switch_interaction():
	on = not on
	update_surface()
