extends Spatial

# Preloads
var _invis_box = preload("res://Scenes/State/InvisibleBox.tscn")

# Nodes
onready var interactables_grid = get_node("InteractablesGrid")
onready var stat_objects = get_node("StaticObjects")

# State
var package = {
	"level" : "",
	"movables" : [],
	"special" : []
}

func _ready():
	interactables_grid.generate_resources()
	interactables_grid.put_machine("Excavator", Vector3(24, 0, 24))

func _unhandled_input(event):
	if Input.is_action_just_pressed("show_hide_grid"):
		var vg = $StaticObjects/VisualGrid
		if vg.visible:
			vg.hide()
		else:
			vg.show()

func place_invis_box(pos):
	var box = _invis_box.instance()
	stat_objects.add_child(box)
	box.global_translate(pos)

#func pack():
#	var pkg = package.duplicate(true)
#	pkg.level = filename
#	# Pack rigidbodies
#	for m in $Movables.get_children():
#		var obj = {
#			"name" : m.name,
#			"trans" : m.transform
#		}
#		pkg.movables.append(obj)
#	# Pack special objects
#	for s in $Special.get_children():
#		var obj = {
#			"name" : s.name,
#			"state" : s.get_state(),
#			"type" : s.get_type(),
#			"desc" : s.get_desc()
#		}
#		pkg.special.append(obj)
#	print(pkg)
#	return pkg
#
#func unpack(pkg):
#	# Unpack rigidbodies
#	for m in pkg.movables:
#		var n = get_node("Movables/" + m.name)
#		n.transform = m.trans
#	# Unpack special nodes
#	for s in pkg.special:
#		var n = get_node("Special/" + s.name)
#		n.set_state(s.state)
#		n.set_type(s.type)
#		n.set_desc(s.desc)
