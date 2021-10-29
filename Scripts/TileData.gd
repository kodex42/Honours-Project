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
var _power_network = null

func _init(td_pos = Vector3(0, 0, 0), td_mac = null, td_occ = false):
	_position = td_pos
	_machine = td_mac
	_occupied = td_occ

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

func has_power(p):
	return get_available_power() >= p

func extract_power(p):
	return 0 if p == 0 else _power_network.extract_power(p)

func attempt_add_power_network(pnet):
	if pnet == _power_network:
		return false
	elif _power_network:
		return true
	else:
		_power_network = pnet
		return false

func remove_power_network():
	_power_network = null

func has_power_network():
	return _power_network == null

func get_power_network():
	return _power_network

func get_available_power():
	if _power_network:
		return _power_network.get_available_power()
	else:
		return 0

func get_pos():
	return Vector2(_position.x, _position.z)

func _to_string():
	print({
		"position" : _position,
		"machine" : _machine,
		"occupied" : _occupied
	})
