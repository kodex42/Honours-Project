extends Spatial

onready var home_app = $PhoneHomeScreen
onready var messages_app = $MessagesScreen

var current_app

func _ready():
	yield(owner, "ready") # Let owner node ready first to access script functions
	home_app.hide()
	messages_app.hide()
	change_app(home_app)

func _process(delta):
	if owner.on:
		if Input.is_action_just_pressed("OpenHomeApp"):
			change_app(home_app)
		if Input.is_action_just_pressed("OpenMessagesApp"):
			change_app(messages_app)

func change_app(app):
	if current_app != app:
		if current_app:
			current_app.hide()
		current_app = app
		current_app.show()
		owner.change_screen(current_app.get_node("Viewport").get_texture())
