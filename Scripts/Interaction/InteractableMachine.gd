extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export var body_name : String
export var produced_resource : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$Machine/AnimationPlayer.get_animation("default").set_loop(true)

func create(tile, pos):
	var resource
	match(produced_resource):
		ResourceType.WOOD:
			resource = "wood"
		ResourceType.WATER:
			resource = "water"
		ResourceType.COAL:
			body_name = "Sooty Rock"
		ResourceType.ROCK_CHUNK:
			resource = "rock chunk"
	tile.set_machine(self)
	self.build(tile, pos, body_name, "Machine", resource)

func interact():
	$Machine/AnimationPlayer.play("default")
