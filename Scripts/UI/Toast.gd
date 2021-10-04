extends PanelContainer

func _ready():
	set_process_input(false)
	hide()

func toast(message, color):
	$MarginContainer/ToastMessage.set_text(message)
	$MarginContainer/ToastMessage.modulate = color
	show()
	
	$Tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 2.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed():
	hide()
