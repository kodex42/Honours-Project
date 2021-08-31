extends GridMap

# Constants
var GRID_SIZE = 50

# State
var _grid_info

func _ready():
	_grid_info = []
	for i in range(GRID_SIZE):
		_grid_info.append([])
		for k in range(GRID_SIZE):
			_grid_info[i].append(TileData.new(Vector3(k, 0, i)))

func _process(delta):
	pass

func get_tile_data_from_coords(pos : Vector3):
	return get_tile_data(pos.x - (GRID_SIZE/2), pos.z - (GRID_SIZE/2))

func get_tile_data(x, z):
	return _grid_info[x][z]
