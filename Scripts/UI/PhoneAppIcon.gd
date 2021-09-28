extends MarginContainer

signal app_opened(app_name)

func _on_Button_pressed():
	emit_signal("app_opened", self.name)
