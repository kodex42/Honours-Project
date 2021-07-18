extends Spatial

# Resources
var a_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_A.png")
var b_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_B.png")
var x_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_X.png")
var y_tex = preload("res://Data/Textures/UI/Prompts/button_prompts_Y.png")

# Constants
const ACCEPTABLE = ["A", "B", "X", "Y"]

# State
var phone_node
var active = false
var prompt_data = {
	"message": "Hello World",
	"button": "N"
}

func _process(delta):
	var z_trans = (global_transform.origin.z + 5) / 6
	$PromptTexture.modulate = Color(z_trans, z_trans, z_trans)
	$PromptTexture.scale = Vector3(z_trans, z_trans, 0)
	if (((prompt_data.button == "A" and Input.is_action_just_pressed("Selection 1")) 
		or (prompt_data.button == "B" and Input.is_action_just_pressed("Selection 2"))
		or (prompt_data.button == "X" and Input.is_action_just_pressed("Selection 3"))
		or (prompt_data.button == "Y" and Input.is_action_just_pressed("Selection 4")))
		and active):
		execute()

func execute():
	print(name + ": executed")
	phone_node.destroy_all_prompts()
#	phone_node.destroy_and_reorder_prompts(self)

func set_active(b):
	active = b

func set_phone_node(n):
	phone_node = n

func set_prompt_button(c, m):
	if typeof(c) != TYPE_STRING or typeof(m) != TYPE_STRING or not ACCEPTABLE.has(c):
		print("Error: Button set as incorrect value, aborting")
		return
	match c:
		"A":
			$Viewport2/Spatial/ButtonPrompt.texture = a_tex
		"B":
			$Viewport2/Spatial/ButtonPrompt.texture = b_tex
		"X":
			$Viewport2/Spatial/ButtonPrompt.texture = x_tex
		"Y":
			$Viewport2/Spatial/ButtonPrompt.texture = y_tex
	prompt_data.button = c
	prompt_data.message = m
	$Viewport/MessageGUI/Container/Label.text = m

func destroy():
	get_parent().remove_child(self)
