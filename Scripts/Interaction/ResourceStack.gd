extends RigidBody

# Exports
export var speed = 1

# State
var reset = false
var new_pos = null
var constant_velocity = Vector3.ZERO
var velocity = Vector3.ZERO
var stack_info = {
	"item_type" : "",
	"amount" : 0
}

func _integrate_forces(state):
	if reset:
		state.transform.origin = new_pos
		reset = false
		show()

func _physics_process(delta):
	if mode == MODE_KINEMATIC:
		velocity = constant_velocity
		global_translate(velocity * delta)

func create(rType, amount):
	stack_info.item_type = rType
	stack_info.amount = amount
	make_static()

func reset_pos():
	if mode == MODE_STATIC or mode == MODE_KINEMATIC:
		transform.origin = Vector3.ZERO

func set_global_pos(pos):
	new_pos = pos
	reset = true

func get_info():
	return stack_info

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
