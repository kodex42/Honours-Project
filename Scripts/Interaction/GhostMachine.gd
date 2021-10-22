extends Position3D

func _on_machine_placement_toggled(is_placing, obj_name):
	if is_placing:
		show()
		$Direction.show()
		get_node(obj_name).show()
		if obj_name == "Inserter":
			$Opposite.show()
	else:
		hide()
		for c in get_children():
			c.hide()
