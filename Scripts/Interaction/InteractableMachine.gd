extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export var body_name : String
export var produced_resource : int
export var machine_category : String

# Nodes
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var powered = false
var machine_stats = {
	"Power" : 1.0,
	"Speed" : 1.0,
	"Efficiency" : 1.0,
	"Range" : 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	var anim = _anim_player.get_animation_list()[0]
	_anim_player.get_animation(anim).set_loop(true)

func create(tile, pos):
	var resource
	match(produced_resource):
		ResourceType.WOOD:
			resource = "wood"
		ResourceType.WATER:
			resource = "water"
		ResourceType.COAL:
			resource = "coal"
		ResourceType.ROCK_CHUNK:
			resource = "rock chunk"
		ResourceType.METAL:
			resource = "metal"
		ResourceType.CASH:
			resource = "cash"
		ResourceType.BYTE:
			resource = "byte"
	tile.set_machine(self)
	self.build(tile, pos, body_name, "Machine", resource)

func is_on():
	return powered

func toggle():
	powered = not powered
	update_anim()

func update_anim():
	var anim = _anim_player.get_animation_list()[0]
	if powered:
		_anim_player.play(anim)
	else:
		_anim_player.stop()
		_anim_player.seek(0, true)

func interact():
	var anim = _anim_player.get_animation_list()[0]
	_anim_player.play(anim)
