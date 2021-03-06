extends Control

# Exports
export(NodePath) onready var _main = get_node(_main)
export(NodePath) onready var _camera_raycast = get_node(_camera_raycast)
export(NodePath) onready var _phone_gui = get_node(_phone_gui)

# Nodes
onready var int_info = $InteractableInfo
onready var int_res_ui = $InteractableResource
onready var int_mac_ui = $InteractableMachine
onready var machining_ui = $MachiningGUITabs
onready var trackables = $ResourcesAndCurrencies
onready var quit_prompt = $QuitPrompt
onready var crosshair = $Crosshair

# State
var _interactable_object
var mouse_mode_to_return_to

func _ready():
	int_res_ui.deactivate()
	int_mac_ui.deactivate()
	GlobalControls.connect("prompt_quit", self, "_on_quit_prompted")
	GlobalControls.connect("unprompt_quit", self, "_on_quit_unprompted")

func _process(delta):
	if Input.is_action_just_pressed("Selection 1") and _interactable_object != null and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and int_info.visible:
		if _interactable_object.get_data().type == "Resource":
			show_interactable_resource_ui()
		if _interactable_object.get_data().type == "Machine":
			show_interactable_machine_ui()
		if _interactable_object.get_data().type == "Resource Stack":
			var stack = _interactable_object.get_info()
			for r in stack.keys():
				if stack[r] > 0:
					_main.add_resource(r, stack[r])
			_interactable_object.queue_free()
		hide_interactable_info()
	if Input.is_action_just_pressed("ui_cancel") and (int_res_ui.visible or int_mac_ui.visible or machining_ui.visible):
		if int_res_ui.visible:
			hide_interactable_resource_ui()
		if int_mac_ui.visible:
			hide_interactable_machine_ui()
		if machining_ui.visible:
			hide_machining_ui()
		int_info.show()
		crosshair.enlarge()

func update_trackables(wood : Big, water : Big, coal : Big, rock_chunks : Big, metal : Big, cash : Big, bytes : Big):
	var trackables_cont = trackables.get_node("MarginContainer/VBoxContainer")
	trackables_cont.get_node("Wood/Label").set_text(wood.toScientific())
	trackables_cont.get_node("Water/Label").set_text(water.toScientific())
	trackables_cont.get_node("Coal/Label").set_text(coal.toScientific())
	trackables_cont.get_node("RockChunks/Label").set_text(rock_chunks.toScientific())
	trackables_cont.get_node("Metal/Label").set_text(metal.toScientific())
	trackables_cont.get_node("Cash/Label").set_text(cash.toScientific())
	trackables_cont.get_node("Bytes/Label").set_text(bytes.toScientific())
	yield(get_tree(), "idle_frame")
	trackables.rect_size.x = 0
	trackables.margin_left = 0
	trackables.margin_right = 0

# Data is structured as below for InteractableBody
#var _data = {
#	"name" : "",
#	"type" : "",
#	"tile" : null
#}

func set_grid_label_text(txt):
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer2/ShowGridLabel.set_text(txt)

func show_interactable_info(obj):
	if obj.get_data().name == "Water":
		return
	
	_interactable_object = obj
	var data = obj.get_data()
	var label_cont = $InteractableInfo/MarginContainer/VBoxContainer
	label_cont.get_node("Name").set_text("Object: " + data.name)
	label_cont.get_node("Type").set_text("Type: " + data.type)
	if data.tile:
		label_cont.get_node("Tile").show()
		label_cont.get_node("Tile").set_text("Tile: (" + str(data.tile.get_pos().x) + ", " + str(data.tile.get_pos().y) + ")")
	else:
		label_cont.get_node("Tile").hide()
	int_info.show()
	crosshair.enlarge()

func show_interactable_resource_ui():
	_phone_gui.phone.disable()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	int_res_ui.build_from_interactable_object(_interactable_object)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.show()
	int_res_ui.activate()
	hide_interactable_info()
	crosshair.hide()

func show_interactable_machine_ui():
	_phone_gui.phone.disable()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	int_mac_ui.build_from_interactable_object(_interactable_object)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.show()
	int_mac_ui.activate()
	hide_interactable_info()
	crosshair.hide()

func show_machining_ui(machine_type):
	_phone_gui.phone.disable()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.show()
	machining_ui.show()
	machining_ui.set_process_input(true)
	hide_interactable_info()
	crosshair.hide()

func hide_interactable_info():
	int_info.hide()
	crosshair.delarge()

func hide_interactable_resource_ui():
	_phone_gui.phone.enable()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.hide()
	$ControlsInfo.hide()
	$ControlsInfo.call_deferred("set_visible", true)
	int_res_ui.deactivate()
	crosshair.show()

func hide_interactable_machine_ui():
	_phone_gui.phone.enable()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.hide()
	$ControlsInfo.hide()
	$ControlsInfo.call_deferred("set_visible", true)
	int_mac_ui.deactivate()
	crosshair.show()

func hide_machining_ui():
	_phone_gui.phone.enable()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer.hide()
	$ControlsInfo.hide()
	$ControlsInfo.call_deferred("set_visible", true)
	machining_ui.hide()
	machining_ui.set_process_input(false)
	crosshair.show()

func toast_err(message):
	$Toast.toast(message, Color.red)

func _on_object_placement(is_placing, obj_name):
	if is_placing:
		$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer3.show()
		$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer4.show()
	else:
		$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer3.hide()
		$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer4.hide()
		$ControlsInfo.hide()
		$ControlsInfo.call_deferred("set_visible", true)

func _on_InteractableObject_resource_count_changed(type, amount):
	_main.add_resource(type, amount)

func _on_quit_prompted():
	_phone_gui.phone.disable()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	quit_prompt.show()
	crosshair.hide()

func _on_quit_unprompted():
	_phone_gui.phone.enable()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	quit_prompt.hide()
	crosshair.show()

func _on_NoQuitButton_pressed():
	GlobalControls.unquit()

func _on_YesQuitButton_pressed():
	GlobalControls.quit(true)

func _on_PhoneGUI_machining_window_opened(machine_type):
	show_machining_ui(machine_type)

func _on_MachiningGUI_machine_craft_requested(machine_name):
	if _main.can_craft(machine_name):
		hide_machining_ui()
		_main.attempt_craft(machine_name)
		crosshair.show()
	else:
		$Toast.toast("You cannot afford to craft that machine", Color.red)

func _on_InteractableMachine_attempt_add_ingredient(res, amount, machine):
	_main.attempt_add_ingredient(res, amount, machine)

func _on_InteractableMachine_machine_dismantled(refund):
	hide_interactable_machine_ui()
	for i in refund.keys():
		_main.add_resource(i, refund[i])

func _on_InteractableMachine_wheel_boarded(wheel):
	hide_interactable_machine_ui()
	_main.player_board_wheel(wheel)

func _on_PlayerCharacter_mounted():
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer5.show()
	$ControlsInfo.hide()
	$ControlsInfo.call_deferred("set_visible", true)

func _on_PlayerCharacter_unmounted():
	$ControlsInfo/MarginContainer/VBoxContainer/HBoxContainer5.hide()
	$ControlsInfo.hide()
	$ControlsInfo.call_deferred("set_visible", true)
