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

# Debug state
var autoadding : String
var autoamount : Big
var autoaddtimer : Timer
var timeradded = false

func _ready():
	update_trackables()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_input(false)
	if Server.ignore_server:
		_on_server_connected()
	else:
		Server.connect("connected", self, "_on_server_connected")
		Server.connect("failed", self, "_on_server_failed")

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
	if Input.is_action_just_pressed("spawn_resource") and Constants.DEBUG:
		var key = event.scancode
		match key:
			KEY_1:
				auto_add_resource("wood")
			KEY_2:
				auto_add_resource("water")
			KEY_3:
				auto_add_resource("coal")
			KEY_4:
				auto_add_resource("rock chunk")
			KEY_5:
				auto_add_resource("metal")
			KEY_6:
				auto_add_resource("cash")
			KEY_7:
				auto_add_resource("byte")

func auto_add_resource(res_type : String):
	autoadding = res_type
	autoamount = Big.new("123456789")
	
	if not timeradded:
		autoaddtimer = Timer.new()
		autoaddtimer.set_wait_time(0.01)
		autoaddtimer.set_one_shot(false)
		autoaddtimer.connect("timeout", self, "_on_AutoAddTimer_timeout")
		add_child(autoaddtimer)
		timeradded = true
	autoaddtimer.stop()
	autoaddtimer.start()

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

func attempt_craft(machine_name):
	var costs = Constants.MACHINE_COSTS[machine_name]
	if player_can_pay(costs):
		_camera.place(machine_name)
		return true
	else:
		return false

func attempt_add_ingredient(res, amount, machine):
	if player_can_input(res, amount):
		var big = string_to_big(res)
		big.minus(amount)
		machine.add_active_ingredient(res, amount)

func player_can_pay(costs):
	if wood.isLargerThanOrEqualTo(costs.wood) and water.isLargerThanOrEqualTo(costs.water) and metal.isLargerThanOrEqualTo(costs.metal) and coal.isLargerThanOrEqualTo(costs.coal):
		return true
	return false

func player_pay(costs):
	wood.minus(costs.wood)
	water.minus(costs.water)
	metal.minus(costs.metal)
	coal.minus(costs.coal)
	update_trackables()

func player_can_input(res, amount):
	var comparing = string_to_big(res)
	return comparing.isLargerThanOrEqualTo(amount)

func string_to_big(res):
	var big : Big
	match res:
		"wood":
			big = wood
		"water":
			big = water
		"rock chunk":
			big = rock_chunks
		"coal":
			big = coal
		"metal":
			big = metal
		"cash":
			big = cash
		"byte":
			big = bytes
	return big

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

func _on_AutoAddTimer_timeout():
	add_resource(autoadding, autoamount)
