extends Resource

class_name TileData

# Position
export(Vector3) var _position

# Occupying machine
export(NodePath) var _machine
export(NodePath) var _resource
export(int) var _resource_type
export(bool) var _has_machine
export(bool) var _occupied

# Power mechanic
export(float) var _power

func _init(td_pos = Vector3(0, 0, 0), td_mac = null, td_occ = false, td_pow = 0.0):
	_position = td_pos
	_machine = td_mac
	_occupied = td_occ
	_power = td_pow

func set_machine(m):
	_machine = m
	_has_machine = true
	set_occupied(true)

func get_machine():
	return _machine

func remove_machine():
	_machine = null
	_has_machine = false
	set_occupied(false)

func set_resource(r):
	_resource = r
	_resource_type = r.get_type()
	if r.get_type() == 1:
		var x = 1
	_has_machine = false
	set_occupied(true)

func get_resource():
	return _resource_type

func get_resource_node():
	return _resource

func set_occupied(b):
	_occupied = b

func is_occupied():
	return _occupied

func has_machine():
	return _has_machine

func get_pos():
	return Vector2(_position.x, _position.z)

func _to_string():
	print({
		"position" : _position,
		"machine" : _machine,
		"occupied" : _occupied,
		"power" : _power
	})
