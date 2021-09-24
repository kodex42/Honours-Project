extends Control

func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		$PhoneViewport.input(event)
