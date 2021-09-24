extends Spatial

var active = false

func _ready():
	set_active(false)

func _process(delta):
	if active:
		if Input.is_action_just_pressed("phone_up"):
			phone_up()
		if Input.is_action_just_pressed("phone_down"):
			phone_down()
		if Input.is_action_just_pressed("phone_right"):
			phone_right()
		if Input.is_action_just_pressed("phone_left"):
			phone_left()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		$PhoneScreenGUIViewport.input(event)

func phone_up():
	print(name + ": Phone Up")

func phone_down():
	print(name + ": Phone Down")

func phone_right():
	print(name + ": Phone Right")

func phone_left():
	print(name + ": Phone Left")

func set_active(b):
	show() if b else hide()
	active = b
