extends Node

# Preloaded Scenes
var prompt_scene = preload("res://Scenes/Interaction/Prompt.tscn")

# State
var holding_response = {}
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

# Responses made by Hapax are created in a dictionary format that includes the response message and possible player prompts
func get_response(msg):
	var res = {
		"msg" : "",
		"prompts" : []
	}
	
	# Incoming huge match case statement for dialogue
	match msg:
		"Hello?":
			res.msg = "Hello, my name is Hapax! Nice to meet you!! :)"
			res.prompts.append("Hello?")
	
	return res

func _on_Phone_message_sent(msg):
	holding_response = get_response(msg)
	$ReplyTimer.start()

func _on_Phone_ready():
	reply("Hello! My name is Hapax! I am a chatbot created by Satyr industries, ask me anything!")
	set_prompts(["Hello?"])

func _on_ReplyTimer_timeout():
	if not holding_response.empty():
		reply(holding_response.msg)
		set_prompts(holding_response.prompts)
		holding_response.clear()
