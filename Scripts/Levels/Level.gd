extends Spatial

# Preloads
var _invis_box = preload("res://Scenes/State/InvisibleBox.tscn")

# Exports
export(NodePath) onready var _gui = get_node(_gui)
export(NodePath) onready var _main = get_node(_main)

# Nodes
onready var interactables_grid = get_node("InteractablesGrid")
onready var tile_grid = get_node("TerrainGridMap")
onready var stat_objects = get_node("StaticObjects")
onready var invis_boxes = get_node("StaticObjects/Floor/CSGCombiner/Subtractor")

# State
var package = {
	"level" : "",
	"movables" : [],
	"special" : []
}

func _unhandled_input(event):
	if Input.is_action_just_pressed("show_hide_grid"):
		if $StaticObjects/VisualGrid.visible:
			hide_grid()
		else:
			show_grid()

func build_level():
	GlobalControls.load_save_data()
	if not interactables_grid.loaded:
		interactables_grid.generate_resources()
#		interactables_grid.benchmark()

func rebuild_level():
	interactables_grid.destroy()
	tile_grid.build_tiles()
	interactables_grid.generate_resources()

func show_grid():
	$StaticObjects/VisualGrid.show()
	_gui.set_grid_label_text("Hide Grid")

func hide_grid():
	$StaticObjects/VisualGrid.hide()
	_gui.set_grid_label_text("Show Grid")

func place_invis_box(pos):
	var box = _invis_box.instance()
	invis_boxes.add_child(box)
	box.global_translate(pos)

func clear_invis_boxes():
	for b in invis_boxes.get_children():
		b.queue_free()

func is_placement_legal(pos):
	var tile = tile_grid.get_tile_data_from_coords(pos)
	return not tile.is_occupied()

func _on_machine_placed(obj_name, pos, rot):
	if is_placement_legal(pos):
		interactables_grid.put_machine(obj_name, pos, rot)
	else:
		_gui.toast_err("That tile is occupied")

func _on_machine_placement_toggled(is_placing, obj_name):
	if is_placing:
		show_grid()
	else:
		hide_grid()

func _on_InteractablesGrid_add_resources_to_player_inventory(res_type, amount):
	_main.add_resource(res_type, amount)
