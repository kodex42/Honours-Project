extends RigidBody

# State
var stack_info = {
	"item_type" : "",
	"amount" : 0
}

func create(rType, amount):
	stack_info.item_type = rType
	stack_info.amount = amount
	make_static()

func make_static():
	mode = RigidBody.MODE_STATIC

func make_rigid():
	mode = RigidBody.MODE_RIGID
