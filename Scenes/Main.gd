extends Spatial

# Nodes
onready var _player_character = $PlayerCharacter
onready var _camera = $Camera
onready var _gui = $Camera/HUD/GUIViewport/GUI
onready var _phone = $Camera/HUD/GUIViewport/PhoneGUI/PhoneViewport/Phone
onready var _level = $World/Level

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
	GlobalControls.load_save_data()

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
			_player_character.wood.plus(amount)
		"water":
			_player_character.water.plus(amount)
		"coal":
			_player_character.coal.plus(amount)
		"rock chunk":
			_player_character.rock_chunks.plus(amount)
		"metal":
			_player_character.metal.plus(amount)
		"cash":
			_player_character.cash.plus(amount)
		"byte":
			_player_character.bytes.plus(amount)
	update_trackables()
#	print("Player recieves " + amount.toString() + " " + res_type + "!")

func update_trackables():
	_gui.update_trackables(_player_character.wood, _player_character.water, _player_character.coal, _player_character.rock_chunks, _player_character.metal, _player_character.cash, _player_character.bytes)

func can_craft(machine_name):
	var costs = Constants.MACHINE_COSTS[machine_name]
	return player_can_pay(costs)

func attempt_craft(machine_name):
	if can_craft(machine_name):
		_camera.place(machine_name)
		return true
	else:
		return false

func attempt_add_ingredient(res, amount, machine):
	if player_can_input(res, amount):
		var big = string_to_big(res)
		big.minus(amount)
		machine.add_active_ingredient(res, amount)
		update_trackables()

func player_can_pay(costs):
	if _player_character.wood.isLargerThanOrEqualTo(costs.wood) and _player_character.water.isLargerThanOrEqualTo(costs.water) and _player_character.metal.isLargerThanOrEqualTo(costs.metal) and _player_character.coal.isLargerThanOrEqualTo(costs.coal):
		return true
	return false

func player_pay(costs):
	_player_character.wood.minus(costs.wood)
	_player_character.water.minus(costs.water)
	_player_character.metal.minus(costs.metal)
	_player_character.coal.minus(costs.coal)
	update_trackables()

func player_can_input(res, amount):
	var comparing = string_to_big(res)
	return comparing.isLargerThanOrEqualTo(amount)

func player_board_wheel(wheel):
	_player_character.board_wheel(wheel)
	_level.show_grid()

func string_to_big(res):
	var big : Big
	match res:
		"wood":
			big = _player_character.wood
		"water":
			big = _player_character.water
		"rock chunk":
			big = _player_character.rock_chunks
		"coal":
			big = _player_character.coal
		"metal":
			big = _player_character.metal
		"cash":
			big = _player_character.cash
		"byte":
			big = _player_character.bytes
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
	GlobalControls.quit(true)

func _on_AutoAddTimer_timeout():
	add_resource(autoadding, autoamount)
