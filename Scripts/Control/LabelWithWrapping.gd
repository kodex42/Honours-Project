extends Label

func _process(delta):
	owner.rect_size.x = 0
	rect_min_size.x = 0
	rect_size.x = 0

func _on_Label_resized():
	if get_rect().size.x > 1248:
		rect_min_size.x = 1248
		autowrap = true
	elif get_rect().size.x < 1248:
		rect_min_size.x = 192
		autowrap = false
