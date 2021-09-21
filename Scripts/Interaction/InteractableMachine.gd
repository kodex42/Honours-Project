extends "res://Scripts/Interaction/InteractableBody.gd"

# Exports
export var body_name : String
export var produced_resource : int

# Nodes
onready var _anim_player = $Machine.get_child(0).get_node("AnimationPlayer")

# State
var on = false

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
			body_name = "Sooty Rock"
		ResourceType.ROCK_CHUNK:
			resource = "rock chunk"
	tile.set_machine(self)
	self.build(tile, pos, body_name, "Machine", resource)

func is_on():
	return on

func toggle():
	on = not on
	update_anim()

func update_anim():
	var anim = _anim_player.get_animation_list()[0]
	if on:
		_anim_player.play(anim)
	else:
		_anim_player.stop()
		_anim_player.seek(0, true)

func interact():
	var anim = _anim_player.get_animation_list()[0]
	_anim_player.play(anim)
