extends GridMap

# Constants
var GRID_SIZE = 50

# State
var _grid_info

# Called when the node enters the scene tree for the first time.
func _ready():
	_grid_info = []
	for i in range(GRID_SIZE):
		_grid_info.append([])
		for k in range(GRID_SIZE):
			_grid_info[i].append(TileData.new(Vector3(i, 0, k)))

func _process(delta):
	pass

