extends Control

# Signals
signal message_sent(msg)
signal message_received(msg)
signal machining_window_opened(machine_type)
signal upgrades_window_opened(upgrade_type)
signal phone_toggled(on)

# Nodes
onready var phone = $PhoneViewport/Phone
onready var orbit_point = $PhoneView/OrbitPoint
onready var screen_collection = $PhoneView/ScreenCollection

# State
var current_prompts = []

func _ready():
	yield(orbit_point, "ready")

func change_screen(screen_node : Node):
	for n in screen_collection.get_children():
		n.hide()
	screen_node.show()
	# Show prompts if screen is MessagesScreen
	check_prompts_active()

func is_messages_open():
	return screen_collection.current_app.name == "MessagesScreen"

func display_prompts(choices):
	if typeof(choices) != TYPE_ARRAY:
		print("Error: Prompts to display is not of type TYPE_ARRAY, aborting")
		return
	clear_prompts(choices)
	if (choices.size() != 0):
		add_prompts(choices)
		check_prompts_active()

func clear_prompts(new_prompts):
	# Clear current prompts
	for n in orbit_point.get_children():
		orbit_point.remove_child(n)
#	orbit_point.rotation.x = 0
	current_prompts = new_prompts

func add_prompts(prompts):
	# Add prompts as children to orbit point
	for i in range(prompts.size()):
		var choice = prompts[i]
		choice.set_phone_node(self)
		orbit_point.add_child(choice)

func check_prompts_active():
	var b = is_messages_open() and phone.is_on()
	orbit_point.visible = b
	for n in current_prompts:
		n.set_active(b)

func destroy_and_reorder_prompts(p):
	current_prompts.erase(p)
	display_prompts(current_prompts)

func destroy_all_prompts():
	current_prompts.clear()
	display_prompts(current_prompts)

func send_message(msg):
	emit_signal("message_sent", msg)

func receive_message(msg):
	emit_signal("message_received", msg)

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		$PhoneViewport.input(event)

func _on_Phone_toggled(on):
	if on:
		screen_collection.show()
	else:
		screen_collection.hide()
	check_prompts_active()
	emit_signal("phone_toggled", on)

func _on_app_opened_from_HomeScreen(app_name):
	if "Machining" in app_name:
		var machine_type = app_name.substr(0, app_name.find("MachiningApp"))
		emit_signal("machining_window_opened", machine_type)
	if "Upgrades" in app_name:
		var upgrade_type = app_name.substr(0, app_name.find("UpgradesApp"))
		emit_signal("upgrades_window_opened", upgrade_type.to_lower())
