extends Spatial

# Main node process
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
