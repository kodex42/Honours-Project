# The Level class is able to deconstruct into and reconstruct from String data
# It accomplishes this with the pack() and unpack(.) functions which return or
# require a dictionary of String data representing the positions and state of
# all objects in the Level.
# Levels must both extend this class and be instanced from this scene.

extends Spatial

# State
var package = {
	"level" : "",
	"movables" : [],
	"special" : []
}

func _ready():
#	var pkg = pack()
#	unpack(pkg)
	pass

func pack():
	var pkg = package.duplicate(true)
	pkg.level = filename
	# Pack rigidbodies
	for m in $Movables.get_children():
		var obj = {
			"name" : m.name,
			"trans" : m.transform
		}
		pkg.movables.append(obj)
	# Pack special objects
	for s in $Special.get_children():
		var obj = {
			"name" : s.name,
			"state" : s.get_state(),
			"type" : s.get_type(),
			"desc" : s.get_desc()
		}
		pkg.special.append(obj)
	print(pkg)
	return pkg

func unpack(pkg):
	# Unpack rigidbodies
	for m in pkg.movables:
		var n = get_node("Movables/" + m.name)
		n.transform = m.trans
	# Unpack special nodes
	for s in pkg.special:
		var n = get_node("Special/" + s.name)
		n.set_state(s.state)
		n.set_type(s.type)
		n.set_desc(s.desc)
