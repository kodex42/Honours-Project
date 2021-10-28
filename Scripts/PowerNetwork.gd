extends Resource

class_name PowerNetwork

# State
var _available_power = 0
var _tiles = []

func create(tiles):
	self._tiles.append_array(tiles)
	for t in self._tiles:
		t.add_power_network(self)

func destroy():
	for t in self._tiles:
		t.remove_power_network(self)
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
