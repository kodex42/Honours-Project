extends Control

# Exports
export(NodePath) onready var parent = get_node(parent)

# Nodes
onready var home_app = $HomeScreen
onready var messages_app = $MessagesScreen

# State
var current_app
var on = false

func change_app(app):
	if current_app != app:
		current_app = app
		update_screen()

func update_screen():
	parent.change_screen(current_app)

func prompt(choices):
	parent.display_prompts(choices)

func _on_Phone_toggled(on):
	self.on = on

func _on_PhoneGUI_ready():
	# Initialize active screen
	current_app = home_app
	update_screen()

func _on_app_opened(app_name):
	match app_name:
		"Home":
			change_app(home_app)
		"MessagingApp":
			change_app(messages_app)
