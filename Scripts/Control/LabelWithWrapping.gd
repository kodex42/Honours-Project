extends Label

# Test variables
var phrases = [
	"Hello World",
	"The quick brown fox jumped over the lazy dog",
	"OK",
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
	"Gotta move that gear up! AAAAAAAAAAAAAAAAAAAAAA"
]
var phrase_set = false

func set_text(msg):
	.set_text(msg)
	owner.rect_size.x = 0
	rect_min_size.x = 0
	rect_size.x = 0

#func _process(delta):
#	var t = OS.get_time().second
#	if t % 2 == 0 and not phrase_set:
#		set_text(phrases[randi() % phrases.size()])
#		phrase_set = true
#	elif t % 2 != 0:
#		phrase_set = false

func _on_Label_resized():
	var rect = get("rect_size")
	if rect.x > 1248:
		set("rect_min_size", Vector2(1248, 0))
		autowrap = true
	elif rect.x < 1248:
		set("rect_min_size", Vector2(160, 0))
		autowrap = false
