extends Control

# Signals
signal message_sent(msg)
signal message_received(msg)

# Nodes
onready var phone = $PhoneViewport/Phone
onready var screen = $PhoneView/Screen
onready var orbit_point = $PhoneView/OrbitPoint
onready var screen_collection = $ScreenCollection

# State
var current_prompts = []

func _ready():
	yield(orbit_point, "ready")

func change_screen(screen_node : Node):
	# Move screens back to collection
	if screen.get_child_count() > 0:
		for n in screen.get_children():
			screen_collection.add_child(n)
			screen.remove_child(n)
	# Move screen from collection to active screen
	screen_collection.remove_child(screen_node)
	screen.add_child(screen_node)
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
		screen.show()
	else:
		screen.hide()
	check_prompts_active()
