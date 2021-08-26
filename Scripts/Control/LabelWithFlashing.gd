extends Label

const SOLID = Color(1.0, 1.0, 1.0, 1.0)
const FADED = Color(1.0, 1.0, 1.0, 0.05)

func _ready():
	Server.connect("failed", self, "_on_server_failed")
	fade_out()

func fade_out():
	$Tween.interpolate_property(self, "modulate", SOLID, FADED, 1.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func fade_in():
	$Tween.interpolate_property(self, "modulate", FADED, SOLID, 1.2, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()

func _on_server_failed():
	text = "Failed to connect, exiting..."

func _on_Tween_tween_completed(object, key):
	if modulate == FADED:
		fade_in()
	else:
		fade_out()
