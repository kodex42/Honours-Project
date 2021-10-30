extends Position3D

func set_preview_ok(ok):
	var material = $PreviewBox.mesh.surface_get_material(0)
	if ok:
		material.set("albedo_color", Color(0.3, 1.0, 0.3, 0.4))
	else:
		material.set("albedo_color", Color(1.0, 0.3, 0.3, 0.4))
#	$PreviewBox.mesh.surface_set_material(0, material)

func reset_position():
	global_transform.origin = Vector3.DOWN * 100

func _on_machine_placement_toggled(is_placing, obj_name):
	for c in get_children():
		c.hide()
	if is_placing:
		show()
		$Direction.show()
		$PreviewBox.show()
		get_node(obj_name).show()
		if obj_name == "Inserter":
			$Opposite.show()
		if obj_name in ["Wheel", "Steam Engine", "Reactor", "Power Tower"]:
			var rad = Constants.BASE_MACHINE_STATS.Range * MachineMods.machine_stat_mods[obj_name].Range
			$PoweringMachineRangeIndicator.set_radius(rad)
			$PoweringMachineRangeIndicator.show()
	else:
		hide()
		reset_position()
