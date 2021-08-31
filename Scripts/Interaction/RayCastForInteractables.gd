extends RayCast

func _process(delta):
	if is_colliding():
		var body = get_collider()
		print(body.get_data())
