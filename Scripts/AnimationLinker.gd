extends Spatial

export(Array, NodePath) onready var anim_players

func _ready():
	for i in range(anim_players.size()):
		var node = anim_players[i]
		var p = get_node(node) as AnimationPlayer
		var anim = p.get_animation_list()[0]
		p.get_animation(anim).set_loop(true)

func play_anim():
	for i in range(anim_players.size()):
		var node = anim_players[i]
		var p = get_node(node) as AnimationPlayer
		var anim = p.get_animation_list()[0]
		p.play(anim)
