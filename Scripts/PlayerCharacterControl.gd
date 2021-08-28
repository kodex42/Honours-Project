extends KinematicBody

# Exports
export(NodePath) onready var _anim_tree = get_node(_anim_tree)
export(NodePath) onready var camera = get_node(camera)

# Constants
const GRAV_FORCE = -25
const SNAP = Vector3(0, -1, 0)

# State variables
var activated = false
var jumping = false
var jump_percentage = 0.0
var _turning_speed = 5.0
var gravity = Vector3.ZERO
var up = Vector3.UP

func _ready():
	activate()

func _physics_process(delta):
	if activated:
		var root_motion : Transform = _anim_tree.get_root_motion_transform()
		var v = root_motion.origin / delta
		var snap

		# Check movement
		v = movement_controls(delta, v)

		# Check jumping flag
		if jumping:
			gravity.y = 0
			snap = Vector3.ZERO
		elif is_on_floor():
			gravity.y = 0
			snap = SNAP
		else:
			gravity.y += GRAV_FORCE*delta
			snap = SNAP

		# Apply gravity
		v += gravity

		# Move character and change state based on result
		move_and_slide_with_snap(v, snap, up, true)
		if is_on_floor():
			up = get_floor_normal()
		else:
			up = Vector3.UP

func movement_controls(delta, v):
	var current_anim = _anim_tree.get("parameters/playback").get_current_node()
	
	# Check jump input
	_anim_tree["parameters/conditions/jump"] = Input.is_action_pressed("jump")
	
	# Set jumping flag for length of jump animation
	jumping = "Jump" in current_anim
	
	# Check directional input
	var dir : Vector3 = Vector3.ZERO
	
	if Input.is_action_pressed("forward"):
		dir.z += 1.0
	if Input.is_action_pressed("backward"):
		dir.z -= 1.0
	if Input.is_action_pressed("left"):
		dir.x += 1.0
	if Input.is_action_pressed("right"):
		dir.x -= 1.0
	
	if dir.length_squared() > 0.01:
		dir = dir.rotated(Vector3.UP, camera.setup.rotation.y)
		
		# Basis = matrix form
		var player_heading_2d := Vector2(self.transform.basis.z.x, self.transform.basis.z.z)
		var desired_heading_2d := Vector2(dir.x, dir.z)
		# Angle of player rotation required
		var phi : float = desired_heading_2d.angle_to(player_heading_2d)
		phi = phi * delta * _turning_speed
		# Apply rotation to body and velocity
		self.rotation.y += phi
		v = v.rotated(Vector3.UP, self.rotation.y)
		if Input.is_action_pressed("sprint"):
			_anim_tree["parameters/playback"].travel("Running")
		else:
			_anim_tree["parameters/playback"].travel("Walking")
	else:
		_anim_tree["parameters/playback"].travel("Idle")
		v = v.rotated(Vector3.UP, self.rotation.y)
	
	return v

func activate():
	activated = true
	
func deactivate():
	activated = false
