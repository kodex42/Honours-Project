extends Spatial

# Signals
signal add_resources_to_player_inventory(res_type, amount)
signal powering_machine_added(machine, pos)

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
	METAL,
	CASH,
	BYTE
}

# Scenes
var _interactable_resource = preload("res://Scenes/Interaction/InteractableResource.tscn")
var _resource_stack = preload("res://Scenes/Interaction/ResourceStack.tscn")
var _interactable_machines = {
	"Excavator" : preload("res://Scenes/Interaction/Excavator.tscn"),
	"Pump" : preload("res://Scenes/Interaction/Pump.tscn"),
	"Sawmill" : preload("res://Scenes/Interaction/Sawmill.tscn"),
	"Miner" : preload("res://Scenes/Interaction/Miner.tscn"),
	"Market" : preload("res://Scenes/Interaction/Market.tscn"),
	"Smelter" : preload("res://Scenes/Interaction/Smelter.tscn"),
	"Burner" : preload("res://Scenes/Interaction/Burner.tscn"),
	"Conveyer" : preload("res://Scenes/Interaction/Conveyer.tscn"),
	"Inserter" : preload("res://Scenes/Interaction/Inserter.tscn"),
	"Accumulator" : preload("res://Scenes/Interaction/Accumulator.tscn"),
	"Power Tower" : preload("res://Scenes/Interaction/Power Tower.tscn"),
	"Wheel" : preload("res://Scenes/Interaction/Wheel.tscn"),
	"Steam Engine" : preload("res://Scenes/Interaction/Steam Engine.tscn"),
	"Reactor" : preload("res://Scenes/Interaction/Reactor.tscn")
}

# Nodes
onready var parent = get_parent()
onready var _grid = get_parent().get_node("TerrainGridMap")
onready var _floor = get_parent().get_node("StaticObjects/Floor")

# State
var loaded = false
var water_bodies = []
var powering_machines = []
var abandoned_bodies = []

func benchmark():
	var lim = _grid.GRID_SIZE
	
	for y in range(lim):
		for x in range(lim):
			var machine = ["Excavator", "Pump", "Sawmill", "Miner"][randi()%4]
			put_machine(machine, Vector3(x, 0, y), true)

func attempt_pull_from_inventory(res):
	var main = parent._main
	if main.player_can_pay(res):
		main.player_pay(res)
		var stack = _resource_stack.instance()
		stack.create_mixed(res)
		return stack
	return null

func create_resource_stack(rType, amount):
	var stack = _resource_stack.instance()
	stack.create(rType, amount)
	return stack

func destroy():
	for c in get_children():
		c.queue_free()
	water_bodies.clear()
	powering_machines.clear()
	abandoned_bodies.clear()
	parent.clear_invis_boxes()

func load_interactables(interactables):
	destroy()
	for i in interactables:
		var grid_pos = dict_to_vector(i.grid_pos)
		if i.type == "Resource":
			var r_type
			match i.name:
				"Water":
					r_type = ResourceType.WATER
				"Sooty Rock":
					r_type = ResourceType.COAL
				"Shiny Rock":
					r_type = ResourceType.ROCK_CHUNK
				_:
					r_type = ResourceType.WOOD
			var body = put_resource(r_type, grid_pos)
			body.set_state(i.inventory, i.stores)
		elif i.type == "Machine":
			var facing_dir = dict_to_vector(i.facing_dir)
			var rot = Vector3(0, 0, 1).angle_to(facing_dir)
			if Vector3(0, 0, 1).cross(facing_dir).dot(Vector3.UP) < 0:
				rot = -rot
			var body = put_machine(i.name, grid_pos, rot)
			body.set_state(i.inventory, i.active_ingredients, i.power)
			if i.on and (body.machine_category == "Gathering" or body.machine_category == "Refining"):
				body.toggle()
	tile_water()
	loaded = true

func generate_resources():
	var lim = _grid.GRID_SIZE
	var x = randi() % lim
	var y = randi() % lim
	
	# Each resource type is clustered in random locations on the grid
	for r_type in [ResourceType.WOOD, ResourceType.WATER, ResourceType.COAL, ResourceType.ROCK_CHUNK]:
		# Place resource cluster
		var num_clusters
		match r_type:
			ResourceType.WOOD:
				num_clusters = 3 if Randomizer.randb() else 2
			ResourceType.WATER:
				num_clusters = 1
			ResourceType.COAL:
				num_clusters = 2 if Randomizer.randb() else 1
			ResourceType.ROCK_CHUNK:
				num_clusters = 2 if Randomizer.randb() else 1
		for i in range(num_clusters):
			# Only allow unoccupied cells
			while(cell_is_occupied(x, y)):
				x = randi() % lim
				y = randi() % lim
			cluster_resource(x, y, lim, r_type)
	# Remake the water tiles to look better connected
	tile_water()

func cluster_resource(x, y, lim, r_type):
#	print("Generating resource cluster for resource type " + str(r_type) + " at (" + str(x) + ", " + str(y) + ")")
	# Assume the given coordinates are not occupied and within bounds
	var chance = 1.0
	var chance_mod
	var minimum_tiles
	match r_type:
		ResourceType.WOOD:
			chance_mod = 0.95
			minimum_tiles = 3
		ResourceType.WATER:
			chance_mod = 0.98
			minimum_tiles = 20
		ResourceType.COAL:
			chance_mod = 0.92
			minimum_tiles = 2
		ResourceType.ROCK_CHUNK:
			chance_mod = 0.90
			minimum_tiles = 2
	while(rand_range(0.0, 1.0) <= chance):
		put_resource(r_type, Vector3(x, 0, y))
		# Give each subsequent resource in the cluster 80% the chance of the previous
		if minimum_tiles > 0:
			minimum_tiles -= 1
		else:
			chance *= chance_mod
		# Calculate next cell
		while(cell_is_occupied(x, y)):
			# Add or subtract 1 from either x or y at random
			var mod = 1 if Randomizer.randb() else -1
			if (Randomizer.randb()):
				x = clamp(x + mod, 0, lim-1)
			else:
				y = clamp(y + mod, 0, lim-1)
#			print("Attempting next cell (" + str(x) + ", " + str(y) + ")")

func cell_is_occupied(x, y):
	# Disallow reserved tiles for player spawn area
	if Vector2(x, y) in [Vector2(24, 24), Vector2(25, 24), Vector2(24, 25), Vector2(25, 25)]:
		return true
	return _grid.get_tile_data(x, y).is_occupied()

func put_resource(type : int, pos = Vector3(0, 0, 0)):
#	print("Placing resource type " + str(type) + " at " + str(pos))
	var lim = _grid.GRID_SIZE
	# Get tile data
	var tile = _grid.get_tile_data_from_coords(pos)
	if not tile:
		return
	# Create an InteractableResource
	var body = _interactable_resource.instance()
	# Generate the resource procedurally
	body.create(type, pos, tile)
	add_child(body)
	# Translate to position
	var global_pos = pos * 2 + Vector3(1, 0, 1) - Vector3(lim, 0, lim)
	body.global_transform.origin = global_pos
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
	# Offset non water tiles for aesthetics
	else:
		body.global_translate(Vector3(rand_range(0.0, 0.5), 0, rand_range(0.0, 0.5)))
		body.rotate_y(rand_range(0, 2*PI))
	
	return body

func put_machine(type : String, pos = Vector3(0, 0, 0), rot = 0):
#	print("Placing machine type " + type + " at " + str(pos))
	var lim = _grid.GRID_SIZE
	# Get tile data
	var tile = _grid.get_tile_data_from_coords(pos)
	if not tile:
		return
	# Instance the correct machine scene and build it
	var body = _interactable_machines[type].instance()
	var global_pos = pos * 2 + Vector3(1, 0, 1) - Vector3(lim, 0, lim)
	var dir = Vector3(0, 0, 1).rotated(Vector3.UP, rot)
	body.set_direction(dir)
	body.set_grid_pos(pos)
	body.create(tile, pos, self)
	add_child(body)
	# Translate to position and rotate
	body.global_transform.origin = global_pos
	body.rotate(Vector3.UP, rot)
	body.connect("add_to_player_inventory", self, "on_machine_adding_to_player_inventory")
	if body.machine_category == "Gathering":
		body.set_resources_in_range(request_resources_in_range(body, pos, dir))
	if body.machine_category == "Powering":
		powering_machines.append(body)
		emit_signal("powering_machine_added", body, global_pos)
	
	return body

func tile_water():
	for b in water_bodies:
		var neighbours = get_neighbours(b)
		var num_neighbours = count_neighbours(neighbours)
		var corners = get_corners(b)
		var num_corners = count_corners(corners)
		
		# Time for a terribly long match case statement
		match num_neighbours:
			1:
				# Ends
				b.replace_mesh("ground_riverEndClosed")
				if neighbours[0]:
					b.rotate_y(PI)
				if neighbours[1]:
					b.rotate_y(-PI/2)
				if neighbours[2]:
					b.rotate_y(0)
				if neighbours[3]:
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
			3:
				# Splits
				b.replace_mesh("ground_riverSide")
				if not neighbours[0]:
					b.rotate_y(0)
					if corners[1] and not corners[2]:
						b.replace_mesh("ground_riverSideLeft")
					if not corners[1] and corners[2]:
						b.replace_mesh("ground_riverSideRight")
					if not corners[1] and not corners[2]:
						b.replace_mesh("ground_riverSideStraight")
				if not neighbours[1]:
					b.rotate_y(PI/2)
					if corners[2] and not corners[3]:
						b.replace_mesh("ground_riverSideLeft")
					if not corners[2] and corners[3]:
						b.replace_mesh("ground_riverSideRight")
					if not corners[2] and not corners[3]:
						b.replace_mesh("ground_riverSideStraight")
				if not neighbours[2]:
					b.rotate_y(PI)
					if corners[3] and not corners[0]:
						b.replace_mesh("ground_riverSideLeft")
					if not corners[3] and corners[0]:
						b.replace_mesh("ground_riverSideRight")
					if not corners[3] and not corners[0]:
						b.replace_mesh("ground_riverSideStraight")
				if not neighbours[3]:
					b.rotate_y(-PI/2)
					if corners[0] and not corners[1]:
						b.replace_mesh("ground_riverSideLeft")
					if not corners[0] and corners[1]:
						b.replace_mesh("ground_riverSideRight")
					if not corners[0] and not corners[1]:
						b.replace_mesh("ground_riverSideStraight")
			4:
				# Fills
				match(num_corners):
					0:
						b.replace_mesh("ground_riverOpen")
					1:
						b.replace_mesh("ground_riverCornerSmall")
						if not corners[0]:
							b.rotate_y(-PI/2)
						if not corners[1]:
							b.rotate_y(0)
						if not corners[2]:
							b.rotate_y(PI/2)
						if not corners[3]:
							b.rotate_y(PI)
					2:
						b.replace_mesh("ground_riverSideOpen")
						if (corners[0] and corners[2]) or (corners[1] and corners[3]):
							b.replace_mesh("ground_riverCrissCross")
							if corners[1]:
								b.rotate_y(PI/2)
						else:
							if corners[0] and corners[1]:
								b.rotate_y(PI/2)
							if corners[1] and corners[2]:
								b.rotate_y(PI)
							if corners[2] and corners[3]:
								b.rotate_y(-PI/2)
							if corners[3] and corners[0]:
								b.rotate_y(0)
					3:
						b.replace_mesh("ground_riverBendOpen")
						if corners[0]:
							b.rotate_y(PI/2)
						if corners[1]:
							b.rotate_y(PI)
						if corners[2]:
							b.rotate_y(-PI/2)
						if corners[3]:
							b.rotate_y(0)
					_:
						b.replace_mesh("ground_riverCross")
			_:
				pass

func get_neighbours(water_body):
	var lim = _grid.GRID_SIZE
	var tile_pos = water_body.get_data().tile.get_pos()
	var un = _grid.get_tile_data(tile_pos.x, tile_pos.y + 1) if tile_pos.y < lim - 1 else null
	var rn = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y) if tile_pos.x < lim - 1 else null
	var dn = _grid.get_tile_data(tile_pos.x, tile_pos.y - 1) if tile_pos.y > 0 else null
	var ln = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y) if tile_pos.x > 0 else null
	
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

func get_corners(water_body):
	var lim = _grid.GRID_SIZE
	var tile_pos = water_body.get_data().tile.get_pos()
	var ur = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y + 1) if tile_pos.x < lim - 1 and tile_pos.y < lim - 1 else null
	var dr = _grid.get_tile_data(tile_pos.x + 1, tile_pos.y - 1) if tile_pos.x < lim - 1 and tile_pos.y > 0 else null
	var dl = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y - 1) if tile_pos.x > 0 and tile_pos.y > 0 else null
	var ul = _grid.get_tile_data(tile_pos.x - 1, tile_pos.y + 1) if tile_pos.x > 0 and tile_pos.y < lim - 1 else null
	
	var corners = [
		ur != null and ur.is_occupied() and ur.get_resource() == ResourceType.WATER,	# Up Right
		dr != null and dr.is_occupied() and dr.get_resource() == ResourceType.WATER,	# Down Right
		dl != null and dl.is_occupied() and dl.get_resource() == ResourceType.WATER,	# Down Left
		ul != null and ul.is_occupied() and ul.get_resource() == ResourceType.WATER 	# Up Left
	]
	
	return corners

func count_corners(corners):
	var i = 0
	for c in corners:
		i += 1 if not c else 0
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

func get_tile_position(pos):
	return [round(clamp(pos.x, 0, _grid.GRID_SIZE-1)), round(clamp(pos.z, 0, _grid.GRID_SIZE-1))]

func get_next_position(pos, dir):
	var next = pos + dir
	return get_tile_position(next)

func request_resources_in_range(requester, pos, dir):
	var in_range = []
	var requester_data = requester.get_data()
	var gather_range = requester.machine_stats.Range
	var next_pos = get_next_position(pos, dir)
	var grid = _grid.get_grid()
	for i in range(gather_range):
		var tile = grid[next_pos[1]][next_pos[0]]
		if tile.is_occupied() and not tile.has_machine():
			var res = tile.get_resource()
			if res == requester.get_production():
				in_range.append(tile.get_resource_node())
	return in_range

func request_machine_in_range(requester, pos, dir):
	var in_range = null
	var next_pos = get_next_position(pos, dir)
	var grid = _grid.get_grid()
	var tile = grid[next_pos[1]][next_pos[0]]
	var tile_pos = tile.get_pos()
	if tile_pos.x != next_pos[0] or tile_pos.y != next_pos[1]:
		print(str(tile_pos) + " does not match " + str(next_pos))
	if tile.is_occupied() and tile.has_machine():
		in_range = tile.get_machine()
	return in_range

func request_tiles_in_radial_range(requester, pos, rRange):
	var grid = _grid.get_grid()
	var origin = get_tile_position(pos)
	var in_range = []
	var rad = rRange
	for x in range(-rad, rad+1):
		for y in range(-rad, rad+1):
			# Do current coordinates fall within a circle with the given radius?
			if x*x + y*y <= rRange*rRange:
				var dx = clamp(x + origin[0], 0, _grid.GRID_SIZE - 1)
				var dy = clamp(y + origin[1], 0, _grid.GRID_SIZE - 1)
				var tile = grid[dy][dx]
				if not (tile in in_range):
					in_range.append(tile)
	return in_range

func dict_to_vector(vec_dict):
	return Vector3(vec_dict.x, vec_dict.y, vec_dict.z)

func on_machine_adding_to_player_inventory(rType, amount):
	emit_signal("add_resources_to_player_inventory", rType, amount)
