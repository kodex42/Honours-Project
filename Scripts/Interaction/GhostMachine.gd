extends Position3D

func set_preview_ok(ok):
	var material = $PreviewBox.mesh.surface_get_material(0)
	if ok:
		material.set("albedo_color", Color(0.3, 1.0, 0.3, 0.4))
	else:
		material.set("albedo_color", Color(1.0, 0.3, 0.3, 0.4))
#	$PreviewBox.mesh.surface_set_material(0, material)

func _on_machine_placement_toggled(is_placing, obj_name):
	if is_placing:
		show()
		$Direction.show()
		$PreviewBox.show()
		get_node(obj_name).show()
		if obj_name == "Inserter":
			$Opposite.show()
	else:
		hide()
		for c in get_children():
			c.hide()
