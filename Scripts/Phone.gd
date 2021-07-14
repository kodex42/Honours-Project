extends Spatial

# Exports
onready var _mesh = get_node("Model/Plane_2").mesh

# State
var togglable = true
var on = false
var rotating = false
var surface_off : SpatialMaterial
var surface_on : SpatialMaterial

func _ready():
	surface_off = _mesh.surface_get_material(0).duplicate()
	surface_on = _mesh.surface_get_material(0).duplicate()
	surface_on.flags_disable_ambient_light = true
	surface_on.flags_transparent = true
	surface_on.albedo_color = Color.white

func change_screen(tex):
	if typeof(tex) == typeof(Texture):
		surface_on.albedo_texture = tex

func toggle():
	if togglable:
		# Change flag
		on = not on
		
		# Move phone using tween
		if on:
			move_phone()
		else:
			rotate_phone()

func is_on():
	return on

func move_phone():
	var diff = 5.5 if on else -5.5
	var tween = get_node("MovementTween")
	var p = get_node("Model")
	tween.interpolate_property(p, "translation:y",
			p.transform.origin.y, p.transform.origin.y + diff, 0.3,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func rotate_phone():
	rotating = true
	var diff = -180 if on else 180
	var tween = get_node("MovementTween")
	var p = get_node("Model")
	tween.interpolate_property(p, "rotation:y",
			p.rotation.y, p.rotation.y + deg2rad(diff), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_MovementTween_tween_started(object, key):
	togglable = false
	if not on:
		_mesh.surface_set_material(0, surface_off)
		$Model/PhoneIcon.flip_v = false

func _on_MovementTween_tween_completed(object, key):
	togglable = true
	if on and rotating:
		rotating = false
		_mesh.surface_set_material(0, surface_on)
		$Model/PhoneIcon.flip_v = true
	elif on and not rotating:
		rotate_phone()
	elif not on and rotating:
		rotating = false
		move_phone()
