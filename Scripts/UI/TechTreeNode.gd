# Adapted from https://joecreager.com/godot-tech-tree/
extends Button

# Signals
signal upgrade_selected(upgrade, uname)
signal upgrade_unselected(upgrade)

# Exports
export(Array, NodePath) onready var _neighbours
export(String) var currency

# State
var neighbours = [] setget set_neighbours
var lines = []
var neighbour_lines = []
var selected = false

func _ready():
	var nodes = []
	for n in _neighbours:
		nodes.append(get_node(n))
	self.neighbours = nodes
	update_lines()

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	if is_hovering(mouse_pos) and not selected:
		selected = true
		emit_signal("upgrade_selected", self, name)
	elif not is_hovering(mouse_pos) and selected:
		selected = false
		emit_signal("upgrade_unselected", self)

func is_hovering(mouse_pos):
	var dx = [rect_global_position.x, rect_global_position.x + rect_size.x]
	var dy = [rect_global_position.y, rect_global_position.y + rect_size.y]
	return mouse_pos.x >= dx[0] and mouse_pos.x <= dx[1] and mouse_pos.y >= dy[0] and mouse_pos.y <= dy[1]

func add_line(neighbour):
	# Create a connecting line between self and a neighbour
	var line = Line2D.new()
	line.width = 2
	line.z_index = -1
	line.add_point(rect_position + rect_size / 2)
	line.add_point(neighbour.rect_position + neighbour.rect_size / 2)
	lines.push_back(line)
	neighbour.neighbour_lines.push_back(line)
	get_parent().add_child(line)

func update_lines():
	# Update the positions of all lines connected to self
	for line in lines:
		line.set_point_position(0, rect_position + rect_size / 2)
	for line in neighbour_lines:
		line.set_point_position(1, rect_position + rect_size / 2)

func set_neighbours(new_neighbours):
	for neighbour in new_neighbours:
		if not neighbours.has(new_neighbours):
			add_line(neighbour)
	neighbours = new_neighbours

func check_applied():
	if name in GlobalMods.get_applied():
		unlock_neighbours()

func perform_upgrade():
	# Apply upgrade
	GlobalMods.apply_upgrade(name)
	get_tree().call_group("persist", "compute_stats")
	unlock_neighbours()

func unlock_neighbours():
	# Unlock neighbours when toggled
	for neighbour in neighbours:
		if not neighbour.name in GlobalMods.get_applied():
			neighbour.disabled = false
	self.disabled = true
	self.release_focus()
	emit_signal("upgrade_unselected", self)

func _on_TechTreeNode_toggled(button_pressed):
	if pressed and button_pressed:
		if GlobalMods.check_affordability(self.currency, self.name):
			perform_upgrade()
