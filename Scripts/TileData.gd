extends Resource

class_name TileData

# Position
export(Vector3) var _position

# Occupying machine
export(NodePath) var _machine
export(bool) var _occupied

# Power mechanic
export(float) var _power

func _init(td_pos = Vector3(0, 0, 0), td_mac = null, td_occ = false, td_pow = 0.0):
	_position = td_pos
	_machine = td_mac
	_occupied = td_occ
	_power = td_pow

func get_pos():
	return _position

func _to_string():
	print({
		"position" : _position,
		"machine" : _machine,
		"occupied" : _occupied,
		"power" : _power
	})
