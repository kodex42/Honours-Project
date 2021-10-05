extends Position3D

func _on_machine_placement_toggled(is_placing, obj_name):
	if is_placing:
		show()
		$MeshInstance.show()
		get_node(obj_name).show()
	else:
		hide()
		for c in get_children():
			c.hide()
