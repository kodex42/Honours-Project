extends Camera

# Signals
signal machine_placement_toggled(is_placing, obj_name)
signal machine_placed(obj_name, pos, rot)

# Exports
export(NodePath) onready var target = get_node(target)
export(NodePath) onready var ghost = get_node(ghost)
export(Resource) var setup

# Nodes
onready var _forward_ray = $GhostRaycast

# Constants
var MOUSE_LOOK_MOD = 0.002
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
var is_placing = false
var placing_machine = null

func _ready():
	# Camera setup
	if setup.target_offset == Vector3.ZERO:
		setup.target_offset = self.transform.origin - target.transform.origin - setup.anchor_offset
	if setup.look_target == Vector3.ZERO:
		setup.look_target = Vector3(0, 0, 100.0)
	setup.pitch_limit.x = deg2rad(setup.pitch_limit.x)
	setup.pitch_limit.y = deg2rad(setup.pitch_limit.y)
	
	place("Miner")

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
	
	if is_placing:
		# Stretch raycast to zoom level
		var end_point = _forward_ray.get_node("EndPoint")
		_forward_ray.cast_to.z = self.zoom - 5
		if _forward_ray.is_colliding():
			end_point.global_transform.origin = _forward_ray.get_collision_point()
		else:
			end_point.global_transform.origin = Vector3.ZERO
			end_point.transform.origin = _forward_ray.cast_to
		
		# Position ghost at the end of the vector or at the collision point
		var pos = end_point.global_transform.origin
		# Refine position such that the ghost always lies on the grid
		pos.y = 0
		pos.x = stepify(pos.x + 1, 2) - 1
		pos.z = stepify(pos.z + 1, 2) - 1
		
		ghost.global_transform.origin = pos

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

func place(obj_name):
	placing_machine = obj_name
	is_placing = true
	emit_signal("machine_placement_toggled", is_placing, obj_name)

func un_place():
	placing_machine = null
	is_placing = false
	emit_signal("machine_placement_toggled", is_placing, null)

func control():
	if stick_pos.length() > 0:
		var dir = stick_pos * STICK_LOOK_MOD
		setup.rotation.y -= dir.x
		setup.rotation.x += dir.y
		setup.rotation.x = clamp(setup.rotation.x, setup.pitch_limit.x, setup.pitch_limit.y)
	if is_placing:
		if Input.is_action_just_pressed("Selection 3"):
			ghost.rotate(Vector3(0, 1, 0), -PI/2)
		if Input.is_action_just_pressed("Selection 1"):
			var ghost_pos = ghost.global_transform.origin
			var grid_pos = Vector3(clamp(ghost_pos.x / 2 - 0.5, -25, 25), 0, clamp(ghost_pos.z / 2 - 0.5, -25, 25)) + Vector3(25, 0, 25)
			emit_signal("machine_placed", placing_machine, grid_pos, ghost.global_transform.basis.get_euler().y)
			print(grid_pos)
			call_deferred("un_place")

func collide():
	var start = target.transform.origin + setup.anchor_offset
	var end = self.transform.origin
	var space_state = get_world().direct_space_state
	var col = space_state.intersect_ray(start, end, [], 2)
	if not col.empty():
		self.transform.origin = col.position - ((end - col.position).normalized())

func zoom(amount):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var mod = clamp(1/(time_between_zooms*10) if time_between_zooms > 0 else 1, 1, 10)
		var new_zoom = clamp(zoom + ZOOM_TICK * amount * mod, MIN_ZOOM, MAX_ZOOM)
		time_between_zooms = 0
		$Tween.interpolate_property(self, "zoom", zoom, new_zoom, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
