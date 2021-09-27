extends Spatial

# Nodes
onready var _player_character = $PlayerCharacter
onready var _camera = $Camera
onready var _gui = $Camera/HUD/GUIViewport/GUI
onready var _phone = $Camera/HUD/GUIViewport/PhoneGUI/PhoneViewport/Phone

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

#func _process(delta):
#	if Input.is_action_just_pressed("debug_upload"):
#		print("debug_upload: input triggered")
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
	if event is InputEventMouseButton:
		$Camera/HUD/GUIViewport.input(event)
	if Constants.DEBUG:
		if Input.is_action_pressed("spawn_resource"):
			var amount = Big.new("1e9")
			match event.scancode:
				KEY_1:
					add_resource("wood", amount)
				KEY_2:
					add_resource("water", amount)
				KEY_3:
					add_resource("coal", amount)
				KEY_4:
					add_resource("rock chunk", amount)
				KEY_5:
					add_resource("metal", amount)
				KEY_6:
					add_resource("cash", amount)
				_:
					add_resource("byte", amount)
			

func add_resource(res_type : String, amount):
	match res_type:
		"wood":
			wood.plus(amount)
		"water":
			water.plus(amount)
		"coal":
			coal.plus(amount)
		"rock chunk":
			rock_chunks.plus(amount)
		"metal":
			metal.plus(amount)
		"cash":
			cash.plus(amount)
		"byte":
			bytes.plus(amount)
	update_trackables()
#	print("Player recieves " + amount.toString() + " " + res_type + "!")

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
