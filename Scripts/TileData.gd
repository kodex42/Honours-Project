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
var _power_networks = []

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
	var total_power = 0
	for n in _power_networks:
		total_power += n.get_available_power()
	return total_power >= p

func extract_power(p):
	if p == 0:
		return 0
	var power_to_draw = p
	var power_draw = 0
	var expected = power_to_draw / _power_networks.size()
	for i in range(0, _power_networks.size()):
		var n = _power_networks[i]
		power_draw = n.extract_power(expected)
		power_to_draw -= power_draw
		if power_draw < expected:
			expected = power_to_draw / _power_networks.size() - i if _power_networks.size() - i > 0 else power_to_draw
		if power_to_draw <= 0:
			break
	return p - power_to_draw

func add_power_network(pnet):
	_power_networks.append(pnet)

func remove_power_network(pnet):
	_power_networks.erase(pnet)

func get_power_networks():
	return _power_networks

func get_available_power():
	var total = 0
	for n in _power_networks:
		total += n.get_available_power()
	return total

func get_pos():
	return Vector2(_position.x, _position.z)

func _to_string():
	print({
		"position" : _position,
		"machine" : _machine,
		"occupied" : _occupied
	})
