extends Spatial

# Signals
signal message_sent(msg)
signal message_received(msg)

# Exports
onready var _model = get_node("Model")
onready var _mesh = get_node("Model/Plane_2").mesh

# Preloaded Scenes
var prompt_scene = preload("res://Scenes/Interaction/Prompt.tscn")

# Nodes
onready var screens = get_node("ScreenCollection")
onready var msg_app = screens.get_node("MessagesScreen")
onready var p_orbit = msg_app.get_node("PromptOrbitPoint")

# State
var togglable = true
var on = false
var rotating = false
var surface_off : SpatialMaterial
var surface_on : SpatialMaterial
var current_prompts = []

func _ready():
	surface_off = _mesh.surface_get_material(0).duplicate()
	surface_on = _mesh.surface_get_material(0).duplicate()
#	surface_on.set("flags_disable_ambient_light", true)
#	surface_on.set("flags_transparent", true)
	surface_on.set("flags_unshaded", true)
#	surface_on.set("flags_albedo_tex_force_srgb", true)
	surface_on.set("albedo_color", Color.white)
	
#	# Test button prompts
#	var test_prompt1 = prompt_scene.instance()
#	test_prompt1.set_prompt_button("X", "test test")
#	var test_prompt2 = prompt_scene.instance()
#	test_prompt2.set_prompt_button("A", "testing tester")
#	var test_prompt3 = prompt_scene.instance()
#	test_prompt3.set_prompt_button("B", "tester testerino")
#	var test_prompt4 = prompt_scene.instance()
#	test_prompt4.set_prompt_button("Y", "testony testino")
#	display_prompts([test_prompt1, test_prompt2, test_prompt3, test_prompt4])

func _process(delta):
	# Chck if phone is toggled
	if Input.is_action_just_pressed("phone_toggle"):
		toggle()

func change_screen(tex):
	if typeof(tex) == typeof(Texture):
		surface_on.set("albedo_texture", tex)
	set_prompts_active(screens.current_app == screens.get_node("MessagesScreen"))

func toggle():
	if togglable:
		# Change flag
		on = not on
		
		# Move phone using tween
		if on:
			screens.show()
			set_prompts_active(screens.current_app == screens.get_node("MessagesScreen"))
			move_phone()
		else:
			screens.hide()
			set_prompts_active(false)
			rotate_phone()

func is_on():
	return on

func move_phone():
	var diff = 14 if on else -14
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

func display_prompts(choices):
	if typeof(choices) != TYPE_ARRAY:
		print("Error: Prompts to display is not of type TYPE_ARRAY, aborting")
		return
	clear_prompts(choices)
	if (choices.size() != 0):
		add_prompts(choices)
		offset_prompts(choices)
		set_prompts_active(true)

func clear_prompts(new_prompts):
	var orbit_point = p_orbit
	# Clear current prompts
	for n in orbit_point.get_children():
		orbit_point.remove_child(n)
	orbit_point.rotation.x = 0
	current_prompts = new_prompts

func add_prompts(prompts):
	var orbit_point = p_orbit
	# Add prompts as children to orbit point
	for i in range(prompts.size()):
		var choice = prompts[i]
		orbit_point.add_child(choice)
		choice.set_scale(Vector3(0.3, 0.3, 0.3))

func offset_prompts(prompts):
	var offset_magnitude = 1.05
	var offset_length = (2*PI) / prompts.size()
	for i in range(prompts.size()):
		var p = prompts[i]
		var x_offset = cos(offset_length * (i+1)) * offset_magnitude
		var y_offset = sin(offset_length * (i+1)) * offset_magnitude
		p.translation = Vector3(0, x_offset, y_offset)

func set_prompts_active(b):
	for n in current_prompts:
		n.set_active(b)
		n.set_phone_node(self)

func destroy_and_reorder_prompts(p):
	current_prompts.erase(p)
	display_prompts(current_prompts)

func destroy_all_prompts():
	current_prompts.clear()
	display_prompts(current_prompts)

func send_message(msg):
	emit_signal("message_sent", msg)

func receive_message(msg):
	emit_signal("message_received", msg)

func _on_MovementTween_tween_started(object, key):
	togglable = false
	if not on:
		_mesh.surface_set_material(0, surface_off)

func _on_MovementTween_tween_completed(object, key):
	togglable = true
	if on and rotating:
		$Model/PhoneTabIconDown.show()
		$Model/PhoneTabIconUp.hide()
		rotating = false
		_mesh.surface_set_material(0, surface_on)
	elif on and not rotating:
		rotate_phone()
	elif not on and rotating:
		$Model/PhoneTabIconDown.hide()
		$Model/PhoneTabIconUp.show()
		rotating = false
		move_phone()
