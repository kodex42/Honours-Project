extends Resource

class_name PowerNetwork

# State
var _res_id = 0
var _available_power = 0
var _tiles = []
var _machines = []
var _networks_to_merge = {}

func create(tiles, machine):
	_res_id = ResourceManager.get_next_id()
	self._machines.append(machine)
	add_tiles(tiles)

func add_tiles(tiles):
	self._tiles.append_array(tiles)
	for t in self._tiles:
		var has_existing = t.attempt_add_power_network(self)
		if has_existing:
			var pnet = t.get_power_network() as PowerNetwork
			_networks_to_merge[pnet.get_res_id()] = pnet
	for k in _networks_to_merge.keys():
		self.merge(_networks_to_merge[k])
	_networks_to_merge.clear()

func force_add_tiles(tiles):
	self._tiles.append_array(tiles)
	for t in self._tiles:
		t.attempt_add_power_network(self)

func recalculate(machine):
	_machines.erase(machine)
	destroy()
	for m in _machines:
		m.call_deferred("create_power_network", null, get_divided_power())

func remove_network_from_tiles():
	for t in self._tiles:
		t.remove_power_network()

func destroy():
	remove_network_from_tiles()
	self._tiles.clear()

func add_power(amount : int):
	self._available_power = round(clamp(self._available_power + amount, 0, 99999999))

func extract_power(amount : int):
	var val = 0
	if self._available_power >= amount:
		val = amount
		add_power(-amount)
	else:
		val = self._available_power
		add_power(-self._available_power)
	return val

func get_available_power():
	return self._available_power

func get_divided_power():
	return get_available_power()/_machines.size()

func get_res_id():
	return _res_id

func merge(pnet : PowerNetwork):
	var new_power = pnet.get_available_power()
	var new_tiles = pnet._tiles
	var machines = pnet._machines
	pnet.remove_network_from_tiles()
	force_add_tiles(new_tiles)
	add_power(new_power)
	self._machines.append_array(machines)
	for m in machines:
		m.power_network = self
