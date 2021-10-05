extends Spatial

# Preloads
var _invis_box = preload("res://Scenes/State/InvisibleBox.tscn")

# Exports
export(NodePath) onready var _gui = get_node(_gui)

# Nodes
onready var interactables_grid = get_node("InteractablesGrid")
onready var tile_grid = get_node("TerrainGridMap")
onready var stat_objects = get_node("StaticObjects")

# State
var package = {
	"level" : "",
	"movables" : [],
	"special" : []
}

func _ready():
	interactables_grid.generate_resources()
#	interactables_grid.put_machine("Excavator", Vector3(24, 0, 24))
#	interactables_grid.put_machine("Pump", Vector3(25, 0, 25))
#	interactables_grid.put_machine("Sawmill", Vector3(24, 0, 25))
#	interactables_grid.put_machine("Miner", Vector3(25, 0, 24))
#	interactables_grid.put_machine("Market", Vector3(25, 0, 24))
#	interactables_grid.put_machine("Smelter", Vector3(25, 0, 24))
#	interactables_grid.put_machine("Burner", Vector3(25, 0, 24))
#	interactables_grid.benchmark()

func _unhandled_input(event):
	if Input.is_action_just_pressed("show_hide_grid"):
		if $StaticObjects/VisualGrid.visible:
			hide_grid()
		else:
			show_grid()

func show_grid():
	$StaticObjects/VisualGrid.show()
	_gui.set_grid_label_text("Hide Grid")

func hide_grid():
	$StaticObjects/VisualGrid.hide()
	_gui.set_grid_label_text("Show Grid")

func place_invis_box(pos):
	var box = _invis_box.instance()
	stat_objects.add_child(box)
	box.global_translate(pos)

func is_placement_legal(pos):
	var tile = tile_grid.get_tile_data_from_coords(pos)
	return not tile.is_occupied()

func _on_machine_placed(obj_name, pos, rot):
	if is_placement_legal(pos):
		interactables_grid.put_machine(obj_name, pos, false, rot)
	else:
		_gui.toast_err("That tile is occupied")

func _on_machine_placement_toggled(is_placing, obj_name):
	if is_placing:
		show_grid()
	else:
		hide_grid()

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
