extends Node

# Preloaded Scenes
var prompt_scene = preload("res://Scenes/Interaction/Prompt.tscn")

# State
var sent_message = ""
var res = {
		"msg" : "",
		"prompts" : [],
		"new" : false
	}

# Nodes
onready var parent = get_parent()

func reply(msg):
	parent.receive_message(msg)
	res.new = false

func set_prompts(prompts):
	# Sort the prompts
	prompts.sort()
	
	# Add to state
	res.prompts.clear()
	for p in prompts:
		res.prompts.append(p)
	
	# Create and instansiate prompt scenes
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
		s.set_prompt_button_deferred(b, p)
		prompt_scenes.append(s)
	parent.display_prompts(prompt_scenes)

# Responses made by Hapax are created in a dictionary format that includes the response message and possible player prompts
func get_response(msg):
	# Erase used prompt
	res.prompts.erase(msg)
	# Compute reply
	match msg:
		"Hello?":
			res.msg = "Hello! Nice to meet you!"
			res.prompts.append("Hello?")
		"Where am I?":
			res.msg = "Well... I'm not sure! But what I do know is how to help you do what you need to."
			set_prompts(["What do I do?"])
		"Who are you?":
			res.msg = "My name is Hapax and I am a chatbot created by Satyr industries! I was made to answer any questions you might have, so ask away!"
		"???":
			res.msg = "!!!"
			res.prompts.append("???")
		"What do I do?":
			res.msg = "Don't worry, I'll explain everything once all features are implemented. For now, just try to break things! If you break something, be sure to let my creator know what broke and how!"
		_:
			return
	res.new = true

func _on_Phone_message_sent(msg):
	get_response(msg)
	if res.new:
		$ReplyTimer.start()

func _on_Phone_ready():
	reply("Hello! My name is Hapax! I am a chatbot created by Satyr industries, ask me anything!")
	set_prompts(["Hello?", "Who are you?", "Where am I?", "???"])

func _on_ReplyTimer_timeout():
	reply(res.msg)
	set_prompts(res.prompts.duplicate())
