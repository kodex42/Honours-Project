extends KinematicBody

# Signals
signal mounted()
signal unmounted()

# Exports
export(NodePath) onready var _main = get_node(_main)
export(NodePath) onready var _camera = get_node(_camera)
export(NodePath) onready var _phone_gui = get_node(_phone_gui)

# Nodes
onready var _anim_tree = $AnimationTree

# Constants
const GRAV_FORCE = -25

# State variables
var wood = Big.new(0)
var water = Big.new(0)
var coal = Big.new(0)
var rock_chunks = Big.new(0)
var metal = Big.new(0)
var cash = Big.new(0)
var bytes = Big.new(0)
var jumping = false
var turning_speed = 10.0
var gravity = Vector3.ZERO
var up = Vector3.UP
var wheel_locked = false
var wheel = null

func _ready():
	compute_stats()

func _physics_process(delta):
	var root_motion : Transform = _anim_tree.get_root_motion_transform()
	var v = root_motion.origin / delta
	var snap = Vector3(0, -1, 0)
	
	# Check movement
	v = movement_controls(delta, v)
	
	# Check jumping flag
	if jumping:
		gravity.y = 0
		snap = Vector3.ZERO
	elif is_on_floor():
		gravity.y = 0
	else:
		gravity.y += GRAV_FORCE*delta
	
	# Normal movement
	if not wheel_locked:
		# Apply gravity
		v += gravity
		
		# Move character and change state based on result
		move_and_slide_with_snap(v, snap, up, true)
		if is_on_floor():
			up = get_floor_normal()
		else:
			up = Vector3.UP
	else:
		var speed = v.length()
		wheel.spin(speed, _anim_tree["parameters/state_machine/playback"].get_current_node() == "Idle")

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and wheel_locked:
		exit_wheel()

func compute_stats():
	var mods = GlobalMods.player_mods
	_anim_tree["parameters/time_scale/scale"] = mods.speed

func movement_controls(delta, v):
	var current_anim = _anim_tree.get("parameters/state_machine/playback").get_current_node()
	
	# Check jump input
	_anim_tree["parameters/state_machine/conditions/jump"] = Input.is_action_pressed("jump") and not wheel_locked
	
	# Set jumping flag for length of jump animation
	jumping = "Jump" in current_anim
	
	# Check directional input
	var dir : Vector3 = Vector3.ZERO
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if wheel_locked:
			if Input.is_action_pressed("forward"):
				dir.z -= 1.0
		else:
			if Input.is_action_pressed("forward"):
				dir.z += 1.0
			if Input.is_action_pressed("backward"):
				dir.z -= 1.0
			if Input.is_action_pressed("left"):
				dir.x += 1.0
			if Input.is_action_pressed("right"):
				dir.x -= 1.0
	
	if dir.length_squared() > 0.01:
		if not wheel_locked:
			dir = dir.rotated(Vector3.UP, _camera.setup.rotation.y)
		
			# Basis = matrix form
			var player_heading_2d := Vector2(self.transform.basis.z.x, self.transform.basis.z.z)
			var desired_heading_2d := Vector2(dir.x, dir.z)
			# Angle of player rotation required
			var phi : float = desired_heading_2d.angle_to(player_heading_2d)
			phi = phi * delta * turning_speed
			# Apply rotation to body and velocity
			self.rotation.y += phi
			v = v.rotated(Vector3.UP, self.rotation.y)
		if not Input.is_action_pressed("sprint"):
			_anim_tree["parameters/state_machine/playback"].travel("Running")
		else:
			_anim_tree["parameters/state_machine/playback"].travel("Walking")
	else:
		_anim_tree["parameters/state_machine/playback"].travel("Idle")
		v = v.rotated(Vector3.UP, self.rotation.y)
	
	return v

func board_wheel(wheel):
	wheel_locked = true
	set_collision_layer_bit(0, false)
	global_transform.origin = wheel.global_transform.origin + Vector3.UP * 0.5
	global_transform.basis = wheel.global_transform.basis
	self.wheel = wheel
	self.wheel.board()
	_phone_gui.phone.disable()
	GlobalControls.exclude()
	emit_signal("mounted")

func exit_wheel():
	wheel_locked = false
	global_transform.origin = wheel.global_transform.origin + wheel.facing_dir.rotated(Vector3.UP, PI/2) + Vector3.UP * 0.1
	set_collision_layer_bit(0, false)
	self.wheel.unboard()
	self.wheel = null
	GlobalControls.call_deferred("unexclude")
	_phone_gui.phone.enable()
	emit_signal("unmounted")

func save():
	return {
		"wood" : self.wood.toString(),
		"water" : self.water.toString(),
		"coal" : self.coal.toString(),
		"rock_chunks" : self.rock_chunks.toString(),
		"metal" : self.metal.toString(),
		"cash" : self.cash.toString(),
		"bytes" : self.bytes.toString()
	}

func load_from_save(data):
	self.wood = Big.new(data.wood)
	self.water = Big.new(data.water)
	self.coal = Big.new(data.coal)
	self.rock_chunks = Big.new(data.rock_chunks)
	self.metal = Big.new(data.metal)
	self.cash = Big.new(data.cash)
	self.bytes = Big.new(data.bytes)
	_main.update_trackables()
	
	if self.bytes.isLargerThan(0):
		_main.emit_signal("byte_upgrades_unlocked")

func _on_PhoneGUI_phone_toggled(on):
	pass # Replace with function body.
