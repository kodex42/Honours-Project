extends Spatial

# Constants
var GRID_SIZE = 50

# State
var _grid_info

func _ready():
	build_tiles()

func _process(delta):
	pass

func get_tile_data_from_coords(pos : Vector3):
	if pos.x >= GRID_SIZE or pos.z >= GRID_SIZE or pos.x < 0 or pos.z < 0:
		return null
	return get_tile_data(int(round(pos.x)), int(round(pos.z)))

func get_tile_data(x, y):
	return _grid_info[y][x]

func get_grid():
	return _grid_info

func build_tiles():
	_grid_info = []
	for i in range(GRID_SIZE):
		_grid_info.append([])
		for k in range(GRID_SIZE):
			_grid_info[i].append(TileData.new(Vector3(k, 0, i)))
