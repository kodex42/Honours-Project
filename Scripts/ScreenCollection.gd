extends Spatial

onready var home_app = $PhoneHomeScreen
onready var messages_app = $MessagesScreen

var current_app

func _ready():
	yield(owner, "ready") # Let owner node ready first to access script functions
	
	# Initialize active screen
	home_app.set_active(true)
	current_app = home_app
	update_screen()

func _process(delta):
	if owner.on:
		if Input.is_action_just_pressed("OpenHomeApp"):
			change_app(home_app)
		if Input.is_action_just_pressed("OpenMessagesApp"):
			change_app(messages_app)

func change_app(app):
	if current_app != app:
		current_app.set_active(false)
		current_app = app
		current_app.set_active(true)
		update_screen()

func update_screen():
	owner.change_screen(current_app.get_node("Viewport").get_texture())

func prompt(choices):
	owner.display_prompts(choices)
