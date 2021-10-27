extends Control

func enlarge():
	var tween = get_node("Tween")
	var texture = get_node("TextureRect")
	tween.interpolate_property(texture, "rect_scale", texture.get("rect_scale"), Vector2(1.5, 1.5), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween.start()

func delarge():
	var tween = get_node("Tween")
	var texture = get_node("TextureRect")
	tween.interpolate_property(texture, "rect_scale", texture.get("rect_scale"), Vector2(0.5, 0.5), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT_IN)
	tween.start()
