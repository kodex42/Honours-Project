extends Control

# Resources
var a_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_A.png")
var b_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_B.png")
var x_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_X.png")
var y_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_Y.png")
var e_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_E.png")
var q_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_Q.png")
var r_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_R.png")
var f_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_F.png")

# Constants
const ACCEPTABLE = ["A", "B", "X", "Y"]

# Exports
onready var prompt_tex = $VBoxContainer/PromptButton
onready var label = $VBoxContainer/Container/Label

# State
var phone_node
var active = false
var prompt_data = {
	"message": "Hello World",
	"button": "N"
}
var deferred = false
var deferred_btn
var deferred_msg

func _ready():
	ControlDecider.connect("controls_changed", self, "_on_controls_changed")
	if deferred:
		set_prompt_button(deferred_btn, deferred_msg)

func _process(delta):
	if (((prompt_data.button == "A" and Input.is_action_just_pressed("Selection 1")) 
		or (prompt_data.button == "B" and Input.is_action_just_pressed("Selection 2"))
		or (prompt_data.button == "X" and Input.is_action_just_pressed("Selection 3"))
		or (prompt_data.button == "Y" and Input.is_action_just_pressed("Selection 4")))
		and active):
		execute()
#	var z_trans = (global_transform.origin.z + 5) / 6
#	prompt_tex.modulate = Color(z_trans, z_trans, z_trans)
#	prompt_tex.scale = Vector3(z_trans, z_trans, 0)

func execute():
	phone_node.send_message(prompt_data.message)
	phone_node.destroy_all_prompts()
#	print(name + ": executed")

func set_active(b):
	active = b

func set_phone_node(n):
	phone_node = n

func set_prompt_button_deferred(c, m):
	deferred_btn = c
	deferred_msg = m
	deferred = true

func set_prompt_button(c, m):
	if typeof(c) != TYPE_STRING or typeof(m) != TYPE_STRING or not ACCEPTABLE.has(c):
		print("Error: Button set as incorrect value, aborting")
		return
	match c:
		"A":
			prompt_tex.texture = a_tex if ControlDecider.is_gamepad() else e_tex
		"B":
			prompt_tex.texture = b_tex if ControlDecider.is_gamepad() else q_tex
		"X":
			prompt_tex.texture = x_tex if ControlDecider.is_gamepad() else r_tex
		"Y":
			prompt_tex.texture = y_tex if ControlDecider.is_gamepad() else f_tex
	prompt_data.button = c
	prompt_data.message = m
	label.text = m

func destroy():
	get_parent().remove_child(self)

func _on_controls_changed(c):
	set_prompt_button(prompt_data.button, prompt_data.message)
