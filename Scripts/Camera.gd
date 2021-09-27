extends Camera

# Exports
export(NodePath) onready var target = get_node(target)
export(Resource) var setup

# Constants
var MOUSE_LOOK_MOD = 0.003
var STICK_LOOK_MOD = 0.1
var RS_DEAD = 0.1
var MAX_ZOOM = -1.4
var MIN_ZOOM = -14.4
var ZOOM_TICK = 0.5

# State
var last_mouse_pos = Vector2(960, 540)
var stick_pos = Vector2(0, 0)
var zoom : float = MAX_ZOOM
var time_between_zooms = 0

func _ready():
	# Camera setup
	if setup.target_offset == Vector3.ZERO:
		setup.target_offset = self.transform.origin - target.transform.origin - setup.anchor_offset
	if setup.look_target == Vector3.ZERO:
		setup.look_target = Vector3(0, 0, 100.0)
	setup.pitch_limit.x = deg2rad(setup.pitch_limit.x)
	setup.pitch_limit.y = deg2rad(setup.pitch_limit.y)

func _process(delta):
	# Check controls
	control()
	
	# Set new origin
	self.transform.origin = target.transform.origin + setup.anchor_offset
	
	# Retrieve resource vectors
	var target_offset = setup.target_offset
	target_offset.z = zoom
	var look_at = setup.look_target
	var up_down_axis = Vector3.RIGHT.rotated(Vector3.UP, setup.rotation.y)
	
	# Apply yaw
	target_offset = target_offset.rotated(Vector3.UP, setup.rotation.y)
	look_at = look_at.rotated(Vector3.UP, setup.rotation.y)
	
	# Apply pitch
	target_offset = target_offset.rotated(up_down_axis, setup.rotation.x)
	look_at = look_at.rotated(up_down_axis, setup.rotation.x)
	
	# Add target transform to look_at to prevent warping at large distances from the origin
	look_at += target.transform.origin
	
	# Move to offset and look at target
	self.transform.origin += target_offset
	self.look_at(look_at, Vector3.UP)
	
	# Check for collision
	collide()
	
	# Increment timers
	time_between_zooms += delta

func _input(event):
	var diff : Vector2
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		diff = -event.relative
		diff *= MOUSE_LOOK_MOD
		setup.rotation.y += diff.x
		setup.rotation.x -= diff.y
		setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)
		last_mouse_pos = event.position
	if event.is_action_pressed("zoom_in"):
		zoom(1)
	if event.is_action_pressed("zoom_out"):
		zoom(-1)
	if event is InputEventJoypadMotion:
		var RLAxis = Input.get_joy_axis(0, JOY_AXIS_2)
		var UDAxis = Input.get_joy_axis(0, JOY_AXIS_3)
		var stickInput = Vector2(RLAxis, UDAxis)
		if stickInput.length() >= RS_DEAD:
			stick_pos = stickInput
		else:
			stick_pos = Vector2(0, 0)

func control():
	if stick_pos.length() > 0:
		var dir = stick_pos * STICK_LOOK_MOD
		setup.rotation.y -= dir.x
		setup.rotation.x += dir.y
		setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)

func collide():
	var start = target.transform.origin + setup.anchor_offset
	var end = self.transform.origin
	var space_state = get_world().direct_space_state
	var col = space_state.intersect_ray(start, end, [], 2)
	if not col.empty():
		self.transform.origin = col.position

func zoom(amount):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mod = clamp(1/(time_between_zooms*10) if time_between_zooms > 0 else 1, 1, 10)
		var new_zoom = clamp(zoom + ZOOM_TICK * amount * mod, MIN_ZOOM, MAX_ZOOM)
		time_between_zooms = 0
		$Tween.interpolate_property(self, "zoom", zoom, new_zoom, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
