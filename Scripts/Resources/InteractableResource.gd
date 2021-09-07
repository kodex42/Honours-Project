extends "res://Scripts/Interaction/InteractableBody.gd"

# Enums
enum ResourceType {
	WOOD,
	WATER,
	COAL,
	ROCK_CHUNK,
}

# Constants
const letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]

func create(type : int, pos : Vector3, tile : TileData):
	var body_name = "resource" 
	match type:
		ResourceType.WOOD:
			body_name = "Tree"
			generate_mesh("tree" + letters[randi() % 7])
		ResourceType.WATER:
			# NEED TO FIX LATER
			body_name = "Tree"
			generate_mesh("tree" + letters[randi() % 7])
		ResourceType.COAL:
			body_name = "Sooty Rock"
			generate_mesh("stone_tall" + letters[randi() % 9])
		ResourceType.ROCK_CHUNK:
			body_name = "Shiny Rock"
			generate_mesh("stone_tall" + letters[randi() % 9])
	build(tile, pos, body_name, "Resource")

# Overrides
func interact():
	print("I am a " + _data.name + " Tile!")
