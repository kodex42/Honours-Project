extends Node

# Preloaded Scenes
var prompt_scene = preload("res://Scenes/Interaction/Prompt.tscn")

# State
var sent_message = ""

func reply(msg):
	owner.receive_message(msg)

func set_prompts(prompts):
	var prompt_scenes = []
	for i in range(prompts.size()):
		var p = prompts[i]
		var s = prompt_scene.instance()
		var b = "A"
		match i:
			0:
				b = "A"
			1:
				b = "B"
			2:
				b = "X"
			3:
				b = "Y"
		s.set_prompt_button(b, p)
		prompt_scenes.append(s)
	owner.display_prompts(prompt_scenes)

func _on_Phone_message_sent(msg):
	var response = get_response(msg)
	reply(response.msg)
	set_prompts(response.prompts)

func _on_Phone_ready():
	reply("Hello! My name is Hapax! I am a chatbot created by Satyr industries, ask me anything!")
	set_prompts(["Hello?"])

# Responses made by Hapax are created in a dictionary format that includes the response message and possible player prompts
func get_response(msg):
	return
