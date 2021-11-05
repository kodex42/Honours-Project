extends Node

# Signals
signal prompt_quit()
signal unprompt_quit()

# Constants
const SAVE_DATA_FILEPATH = "user://save_game.save"

# State
var excluded = false

func _unhandled_input(event):
	if Input.is_action_just_pressed("ui_cancel") and not excluded:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			quit()
		else:
			unquit()

func exclude():
	excluded = true

func unexclude():
	excluded = false

func quit(are_you_sure = false):
	if are_you_sure:
		save_and_close()
	else:
		emit_signal("prompt_quit")

func unquit():
	emit_signal("unprompt_quit")

func load_save_data():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_DATA_FILEPATH):
		return
	
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for n in save_nodes:
		if not n.is_in_group("player") and n.is_instanced():
			n.queue_free()
	
	save_game.open(SAVE_DATA_FILEPATH, File.READ)
	var save_data = parse_json(save_game.get_line())
	save_game.close()
	
	if save_data.has("upgrades"):
		GlobalMods.set_applied(save_data.upgrades)
	if save_data.has("player"):
		var player = get_tree().get_nodes_in_group("player")[0]
		player.load_from_save(save_data.player)
	if save_data.has("interactables"):
		var interactables_grid = get_tree().get_nodes_in_group("int_manager")[0]
		interactables_grid.load_interactables(save_data.interactables)

func create_save_data():
	var save_data = {
		"upgrades" : GlobalMods.get_applied(),
		"player" : {},
		"interactables" : []
	}
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for n in save_nodes:
		if !n.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % n.name)
			continue
		
		if n.is_in_group("player"):
			save_data["player"] = n.save()
		elif n.is_instanced():
			save_data["interactables"].append(n.save())
	return save_data

func save():
	var save_data = create_save_data()
	var save_game = File.new()
	save_game.open(SAVE_DATA_FILEPATH, File.WRITE)
	save_game.store_line(to_json(save_data))
	save_game.close()

func save_and_close():
	save()
	get_tree().quit()
