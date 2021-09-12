extends Resource

class_name TileData

# Position
export(Vector3) var _position

# Occupying machine
export(NodePath) var _machine
export(int) var _resource_type
export(bool) var _occupied

# Power mechanic
export(float) var _power

func _init(td_pos = Vector3(0, 0, 0), td_mac = null, td_occ = false, td_pow = 0.0):
	_position = td_pos
	_machine = td_mac
	_occupied = td_occ
	_power = td_pow

func set_resource(r):
	_resource_type = r
	set_occupied(true)

func set_occupied(b):
	_occupied = b

func get_resource():
	return _resource_type

func is_occupied():
	return _occupied

func get_pos():
	return Vector2(_position.x, _position.z)

func _to_string():
	print({
		"position" : _position,
		"machine" : _machine,
		"occupied" : _occupied,
		"power" : _power
	})
