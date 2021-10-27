extends RigidBody

# Exports
export var size_scale = 0.2

# Nodes
onready var abandonment_timer = $AbandonmentTimer
onready var collision_shape = $CollisionShape
onready var mesh_instances = {
	"wood" : $WoodMeshInstance,
	"water" : $WaterMeshInstance,
	"coal" : $CoalMeshInstance,
	"rock chunk" : $RockChunkMeshInstance,
	"metal" : $MetalMeshInstance,
	"cash" : $CashMeshInstance,
	"merged" : $MixdMeshInstance
}

# State
var reset = false
var new_pos = null
var is_mix = false
var current_mesh = null
var constant_velocity = Vector3.ZERO
var velocity = Vector3.ZERO
var stack_info = {
	"item_type" : ""
}
var stack = {
	"wood" : 0,
	"water" : 0,
	"coal" : 0,
	"rock chunk" : 0,
	"metal" : 0,
	"cash" : 0
}

func _ready():
	swap_mesh(stack_info.item_type)
	update_scale()

func _integrate_forces(state):
	if reset:
		state.transform.origin = new_pos
		reset = false

func _physics_process(delta):
	if mode == MODE_KINEMATIC:
		velocity = constant_velocity
		global_translate(velocity * delta)

func create(rType, amount):
	self.stack_info.item_type = rType
	stack[rType] = amount
	make_static()

func swap_mesh(rType):
	if current_mesh:
		current_mesh.hide()
	current_mesh = mesh_instances[rType]
	current_mesh.show()

func update_scale(col = false):
	var s = clamp(get_stack_sum_rank() * 0.05 + 0.1, 0.1, 0.3)
	if col:
		collision_shape.scale = Vector3(s, s, s)
	else:
		for i in mesh_instances.keys():
			mesh_instances[i].scale = Vector3(s, s, s)

func has_different_info(p):
	if p.is_mix or is_mix:
		return true
	else:
		return stack_info.item_type != p.stack_info.item_type

func add_info(payload):
	if not is_mix and has_different_info(payload):
		is_mix = true
		swap_mesh("merged")
	merge_stacks(payload)
	payload.queue_free()
	update_scale()

func merge_stacks(p):
	var p_stack = p.stack
	for r in ["wood", "water", "coal", "rock chunk", "metal", "cash"]:
		stack[r] += p_stack[r]

func get_stack_sum_rank():
	return get_stack_sum() * 0.05

func get_stack_sum():
	var sum = 0
	for r in stack.keys():
		sum += stack[r]
	return sum

func disable_collision():
	collision_shape.disabled = true

func enable_collision():
	collision_shape.disabled = false

func abandon():
	abandonment_timer.start()
	make_rigid()
	update_scale(true)
	set_collision_layer_bit(2, true)

func reset_pos():
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin = Vector3.ZERO

func reset_vert():
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin.y = 0

func set_pos(pos):
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin = pos

func get_pos():
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		return transform.origin
	return Vector3.ZERO

func shift_up(amount):
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin.y += amount * size_scale

func set_global_pos(pos):
	new_pos = pos
	reset = true

func get_info():
	return stack

func get_data():
	return {
		"name" : "Resource Stack",
		"type" : "Resource Stack",
		"tile" : null
	}

func set_constant_velocity(vel):
	constant_velocity = vel

func make_static():
	mode = RigidBody.MODE_STATIC

func make_rigid():
	mode = RigidBody.MODE_RIGID

func make_kinematic():
	mode = RigidBody.MODE_KINEMATIC

func _on_AbandonmentTimer_timeout():
	queue_free()
