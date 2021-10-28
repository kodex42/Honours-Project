extends Resource

class_name PowerNetwork

# State
var _available_power = 0
var _tiles = []
var _machines = []

func create(tiles, machine):
	self._machines.append(machine)
	add_tiles(tiles)

func add_tiles(tiles):
	self._tiles.append_array(tiles)
	for t in self._tiles:
		var has_existing = t.attempt_add_power_network(self)
		if has_existing:
			t.get_power_network().merge(self)
			break

func destroy():
	for t in self._tiles:
		t.remove_power_network()

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

func merge(pnet : PowerNetwork):
	var new_power = pnet.get_available_power()
	var new_tiles = pnet._tiles
	var machines = pnet._machines
	pnet.destroy()
	add_tiles(new_tiles)
	add_power(new_power)
	self._machines.append_array(machines)
	for m in machines:
		m.power_network = self
