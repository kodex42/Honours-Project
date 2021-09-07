extends Spatial

# Nodes
onready var _player_character = $PlayerCharacter
onready var _camera = $Camera
onready var _phone = $PhoneViewport/Phone
onready var _gui = $Camera/HUD/GUIViewport/GUI

# State
var wood = Big.new(0)
var water = Big.new(0)
var coal = Big.new(0)
var rock_chunks = Big.new(0)
var metal = Big.new(0)
var cash = Big.new(0)
var bytes = Big.new(0)

func _ready():
	update_trackables()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_input(false)
	if Server.ignore_server:
		_on_server_connected()
	else:
		Server.connect("connected", self, "_on_server_connected")
		Server.connect("failed", self, "_on_server_failed")

func _process(delta):
	if Input.is_action_just_pressed("debug_upload"):
		print("debug_upload: input triggered")
#		send_level_package("TestLevel")

#func request_level_package(level_name):
#	$PlayerCharacter.deactivate()
#	Server.fetch_level(level_name, get_instance_id())
#
#func send_level_package(level_name):
#	var level = $World.get_node(level_name)
#	var pkg = level.pack()
#	Server.send_level(level_name, pkg)
#
#func load_level_from_package(pkg):
#	var level_scene = load(pkg.level)
#	var level = level_scene.instance()
#	level.connect("ready", self, "_on_level_loaded", [level, pkg])
#	$World.add_child(level)
#
#func _on_level_loaded(level, pkg):
#	level.unpack(pkg)
#	$PlayerCharacter.activate()

func _unhandled_input(event):
	$Camera/HUD/GUIViewport.input(event)

func update_trackables():
	_gui.update_trackables(wood, water, coal, rock_chunks, metal, cash, bytes)

func get_player():
	return _player_character

func get_phone():
	return _phone

func set_input(b):
	_player_character.set_process(b)
	_camera.set_process(b)
	_phone.set_process(b)

func _on_server_connected():
	set_input(true)
#	request_level_package("TestLevel")

func _on_server_failed():
	$CloseTimer.start()

func _on_CloseTimer_timeout():
	get_tree().quit()
