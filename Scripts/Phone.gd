extends Spatial

# Signals
signal toggled(on)

# Exports
export(NodePath) onready var parent = get_node(parent)

# Nodes
onready var _model = get_node("Model")
onready var _mesh = get_node("Model/Plane_2").mesh

# State
var togglable = true
var on = false
var rotating = false

func _process(delta):
	# Chck if phone is toggled
	if Input.is_action_just_pressed("phone_toggle"):
		toggle()

func toggle():
	if togglable:
		# Change flag
		on = not on
		
		# Move phone using tween
		if on:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			move_phone()
			GlobalControls.exclude()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			rotate_phone()
			GlobalControls.unexclude()

func toggle_set(b):
	on = b
	
	# Move phone using tween
	if on:
		move_phone()
		GlobalControls.exclude()
	else:
		rotate_phone()
		GlobalControls.unexclude()

func is_on():
	return on

func move_phone():
	var diff = 16 if on else -16
	var tween = get_node("MovementTween")
	tween.interpolate_property(_model, "translation:y",
			_model.transform.origin.y, _model.transform.origin.y + diff, 0.3,
			Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func rotate_phone():
	rotating = true
	var diff = -180 if on else 180
	var tween = get_node("MovementTween")
	tween.interpolate_property(_model, "rotation:y",
			_model.rotation.y, _model.rotation.y + deg2rad(diff), 0.15,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func disable():
	if on:
		toggle()
	togglable = false

func enable():
	togglable = true

func _on_MovementTween_tween_started(object, key):
	togglable = false
	if not on:
		emit_signal("toggled", false)

func _on_MovementTween_tween_completed(object, key):
	togglable = true
	if on and rotating:
		_model.get_node("PhoneTabIconDown").show()
		_model.get_node("PhoneTabIconUp").hide()
		rotating = false
		emit_signal("toggled", true)
	elif on and not rotating:
		rotate_phone()
	elif not on and rotating:
		_model.get_node("PhoneTabIconDown").hide()
		_model.get_node("PhoneTabIconUp").show()
		rotating = false
		move_phone()
