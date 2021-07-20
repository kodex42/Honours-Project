extends Label

# Test variables
var phrases = [
	"Hello World",
	"The quick brown fox jumped over the lazy dog",
	"OK",
	"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
	"Gotta move that gear up!"
]
var phrase_set = false

func _process(delta):
	owner.rect_size.x = 0
	rect_min_size.x = 0
	rect_size.x = 0
	
	var t = OS.get_time().second
	if t % 2 == 0 and not phrase_set:
		set_text(phrases[randi() % 5])
		phrase_set = true
	elif t % 2 != 0:
		phrase_set = false

func set_text(txt):
	.set_text(txt)

func _on_Label_resized():
	if get_rect().size.x > 1248:
		rect_min_size.x = 1248
		autowrap = true
	elif get_rect().size.x < 1248:
		rect_min_size.x = 192
		autowrap = false
