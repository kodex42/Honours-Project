# The Level class is able to deconstruct into and reconstruct from String data
# It accomplishes this with the pack() and unpack(.) functions which return or
# require a dictionary of String data representing the positions and state of
# all objects in the Level.
# Levels must both extend this class and be instanced from this scene.

extends Spatial

# State
var package = {
	"level" : "",
	"movables" : []
}

func _ready():
	pack()

func pack():
	var pkg = package.duplicate(true)
	pkg.level = filename
	for m in $Movables.get_children():
		var obj = {
			"name" : "",
			"trans" : ""
		}
		obj.name = m.name
		obj.trans = str(m.transform)
		pkg.movables.append(obj)
	print(pkg)
