extends Spatial

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_input(false)
	if Server.ignore_server:
		_on_server_connected()
	else:
		Server.connect("connected", self, "_on_server_connected")
		Server.connect("failed", self, "_on_server_failed")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
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

func set_input(b):
	$PlayerCharacter.set_process(b)
	$Camera.set_process(b)
	$Phone.set_process(b)

func _on_server_connected():
	set_input(true)
#	request_level_package("TestLevel")

func _on_server_failed():
	$CloseTimer.start()

func _on_CloseTimer_timeout():
	get_tree().quit()
