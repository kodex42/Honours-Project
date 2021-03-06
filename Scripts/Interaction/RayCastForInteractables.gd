extends RayCast

# Nodes
onready var gui = get_parent().get_node("HUD/GUIViewport/GUI")
onready var camera = get_parent()

# State
var colliding_body

func _process(delta):
	if is_colliding() and colliding_body != get_collider():
		colliding_body = get_collider()
		if colliding_body:
			gui.show_interactable_info(colliding_body)
	elif not is_colliding() or not enabled:
		colliding_body = null
		gui.hide_interactable_info()
