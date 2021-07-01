extends Camera

# Exports
export(NodePath) onready var target = get_node(target)
export(Resource) var setup

# Constants
var MOUSE_LOOK_MOD = 0.01
var STICK_LOOK_MOD = 0.1
var RS_DEAD = 0.1

# State
var last_mouse_pos = Vector2(0, 0)
var stick_pos = Vector2(0, 0)

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
	var look_at = setup.look_target
	var up_down_axis = Vector3.RIGHT.rotated(Vector3.UP, setup.rotation.y)
	
	# Apply Yaw
	target_offset = target_offset.rotated(Vector3.UP, setup.rotation.y)
	look_at = look_at.rotated(Vector3.UP, setup.rotation.y)
	
	# Apply Pitch
	target_offset = target_offset.rotated(up_down_axis, setup.rotation.x)
	look_at = look_at.rotated(up_down_axis, setup.rotation.x)
	
	# Move to offset and look at target
	self.transform.origin += target_offset
	self.look_at(look_at, Vector3.UP)
	# Check for collision
	collide()

func _unhandled_input(event):
	var diff : Vector2
	if event is InputEventMouseMotion:
		diff = last_mouse_pos - event.position
		diff *= MOUSE_LOOK_MOD
		setup.rotation.y += diff.x
		setup.rotation.x -= diff.y
		setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)
		last_mouse_pos = event.position
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
	var col = space_state.intersect_ray(start, end)
	if not col.empty():
		self.transform.origin = col.position
















