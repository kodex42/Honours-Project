extends Spatial

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
}

# Scenes
var _interactable_resource = preload("res://Scenes/Interaction/InteractableResource.tscn")

# Nodes
onready var parent = get_parent()
onready var _grid = get_parent().get_node("TerrainGridMap")
onready var _floor = get_parent().get_node("StaticObjects/Floor")

# State
var water_bodies = []

func generate_resources():
	var lim = _grid.GRID_SIZE
	var x = randi() % lim
	var y = randi() % lim
	
	# Each resource type is clustered in random locations on the grid
	for r_type in [ResourceType.WOOD, ResourceType.WATER, ResourceType.COAL, ResourceType.ROCK_CHUNK]:
		# Only allow unoccupied cells
		while(cell_is_occupied(x, y)):
			x = randi() % lim
			y = randi() % lim
		# Place resource cluster
		cluster_resource(x, y, lim, r_type)
	# Remake the water tiles to look better connected
	tile_water()

func cluster_resource(x, y, lim, r_type):
	# Assume the given coordinates are not occupied and within bounds
	var chance = 1.0
	var chance_mod
	match r_type:
		ResourceType.WOOD:
			chance_mod = 0.95
		ResourceType.WATER:
			chance_mod = 0.98
		ResourceType.COAL:
			chance_mod = 0.92
		ResourceType.ROCK_CHUNK:
			chance_mod = 0.90
	while(rand_range(0.0, 1.0) <= chance):
		put_resource(r_type, Vector3(x, 0, y))
		# Give each subsequent resource in the cluster 80% the chance of the previous
		chance *= chance_mod
		# Calculate next cell
		while(cell_is_occupied(x, y)):
			# Add or subtract 1 from either x or y at random
			var mod = 1 if Randomizer.randb() else -1
			if (Randomizer.randb()):
				x = clamp(x + mod, 0, lim-1)
			else:
				y = clamp(y + mod, 0, lim-1)

func cell_is_occupied(x, y):
	# Disallow reserved tiles for player spawn area
	if Vector2(x, y) in [Vector2(24, 24), Vector2(25, 24), Vector2(24, 25), Vector2(25, 25)]:
		return true
	return _grid.get_tile_data(x, y).is_occupied()

func put_resource(type : int, pos = Vector3(0, 0, 0)):
	var lim = _grid.GRID_SIZE
	# Get tile data
	var tile = _grid.get_tile_data_from_coords(pos)
	# Create an InteractableResource
	var body = _interactable_resource.instance()
	body.create(type, pos, tile)
	add_child(body)
	# Translate to position
	var global_pos = pos * 2 + Vector3(1, 0, 1) - Vector3(lim, 0, lim)
	body.global_translate(global_pos)
	# Use CSGBox to prevent clipping between floor and water tiles
	if type == ResourceType.WATER:
		var box = CSGBox.new()
		_floor.get_node("CSGCombiner/Subtractor").add_child(box)
		box.operation = CSGShape.OPERATION_UNION
		box.global_translate(global_pos)
		# Add body to an array for making cleaner water tiles later
		water_bodies.append(body)
		# Add an invisible collision box over top the water tile
		parent.place_invis_box(global_pos)

func tile_water():
	for b in water_bodies:
		var neighbours = get_neighbours(b)
		var num = count_neighbours(neighbours)
		
		# Time for a terribly long match case statement
		match num:
			1:
				# Ends
				b.replace_mesh("ground_riverEndClosed")
				if neighbours[0]:
					b.rotate_y(PI)
				elif neighbours[1]:
					b.rotate_y(-PI/2)
				elif neighbours[2]:
					b.rotate_y(0)
				elif neighbours[3]:
					b.rotate_y(PI/2)
			2:
				# Corners
				if (neighbours[0] and neighbours[1]) or (neighbours[1] and neighbours[2]) or (neighbours[2] and neighbours[3]) or (neighbours[3] and neighbours[0]):
					if is_bend(b, neighbours):
						b.replace_mesh("ground_riverBend")
					else:
						b.replace_mesh("ground_riverCorner")
					if neighbours[0] and neighbours[1]:
						b.rotate_y(PI)
					if neighbours[1] and neighbours[2]:
						b.rotate_y(-PI/2)
					if neighbours[2] and neighbours[3]:
						b.rotate_y(0)
					if neighbours[3] and neighbours[0]:
						b.rotate_y(PI/2)
				if (neighbours[0] and neighbours[2]) or (neighbours[1] and neighbours[3]):
					b.replace_mesh("ground_riverStraight")
					if neighbours[1]:
						b.rotate_y(PI/2)
			4:
				b.replace_mesh("ground_riverOpen")
				6
			_:
				pass

func get_neighbours(water_body):
	var lim = _grid.GRID_SIZE
	var tile_pos = water_body.get_data().tile.get_pos()
	var un = _grid.get_tile_data(tile_pos.x, tile_pos.y + 1) if tile_pos.y < lim - 1 else null
	var rn = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y) if tile_pos.x < lim - 1 else null
	var dn = _grid.get_tile_data(tile_pos.x, tile_pos.y - 1) if tile_pos.y > 1 else null
	var ln = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y) if tile_pos.x > 1 else null
	
	var neighbours = [
		un != null and un.is_occupied() and un.get_resource() == ResourceType.WATER,	# Up
		rn != null and rn.is_occupied() and rn.get_resource() == ResourceType.WATER,	# Right
		dn != null and dn.is_occupied() and dn.get_resource() == ResourceType.WATER,	# Down
		ln != null and ln.is_occupied() and ln.get_resource() == ResourceType.WATER 	# Left
	]
	
	return neighbours

func count_neighbours(neighbours):
	var i = 0
	for n in neighbours:
		i += 1 if n else 0
	return i

func is_bend(body, neighbours):
	var tile_pos = body.get_data().tile.get_pos()
	var corner_tile
	if neighbours[0] and neighbours[1]:
		corner_tile = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y + 1)
	elif neighbours[1] and neighbours[2]:
		corner_tile = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y - 1)
	elif neighbours[2] and neighbours[3]:
		corner_tile = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y - 1)
	elif neighbours[3] and neighbours[0]:
		corner_tile = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y + 1)
	else:
		return true
	return not corner_is_water(corner_tile)

func corner_is_water(tile):
	return tile.is_occupied() and tile.get_resource() == ResourceType.WATER
