extends RigidBody

# Exports
export var size_scale = 0.2

# Nodes
onready var abandonment_timer = $AbandonmentTimer

# State
var reset = false
var new_pos = null
var constant_velocity = Vector3.ZERO
var velocity = Vector3.ZERO
var stack_info = {
	"item_type" : "",
	"amount" : 0
}
var stack = []

func _integrate_forces(state):
	if reset:
		state.transform.origin = new_pos
		reset = false

func _physics_process(delta):
	if mode == MODE_KINEMATIC:
		velocity = constant_velocity
		global_translate(velocity * delta)

func create(rType, amount):
	add_info([{
		"item_type": rType, 
		"amount" : amount
		}])
	make_static()

func add_info(info_stack):
	for info in info_stack:
		var new_info = stack_info.duplicate()
		new_info.item_type = info.item_type
		new_info.amount = info.amount
		stack.append(new_info)

func abandon():
	abandonment_timer.start()

func reset_pos():
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin = Vector3.ZERO

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
