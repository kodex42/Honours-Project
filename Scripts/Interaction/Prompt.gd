extends Spatial

# Resources
var a_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_A.png")
var b_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_B.png")
var x_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_X.png")
var y_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_Y.png")

# Constants
const ACCEPTABLE = ["A", "B", "X", "Y"]

# State
var prompt_data = {
	"message": "Hello World",
	"button": "N"
}

func _process(delta):
	if ((prompt_data.button == "A" and Input.is_action_just_pressed("Selection 1")) 
	or (prompt_data.button == "B" and Input.is_action_just_pressed("Selection 2"))
	or (prompt_data.button == "X" and Input.is_action_just_pressed("Selection 3"))
	or (prompt_data.button == "Y" and Input.is_action_just_pressed("Selection 4"))):
		execute()

func execute():
	get_parent().remove_child(self)

func set_prompt_button(c, m):
	if typeof(c) != TYPE_STRING or typeof(m) != TYPE_STRING or not ACCEPTABLE.has(c):
		print("Error: Button set as incorrect value, aborting")
		return
	match c:
		"A":
			$ButtonPrompt.texture = a_tex
		"B":
			$ButtonPrompt.texture = b_tex
		"X":
			$ButtonPrompt.texture = x_tex
		"Y":
			$ButtonPrompt.texture = y_tex
	prompt_data.button = c
	prompt_data.message = m
	$Viewport/MessageGUI/Container/Label.text = m
