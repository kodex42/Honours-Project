extends Spatial

# Signals
signal button_pressed

# State
var active = false

func _ready():
	$Prompt.set_prompt_button("A", "Press")
	$Prompt/PromptTexture.billboard = SpatialMaterial.BILLBOARD_DISABLED

func _process(delta):
	if active and Input.is_action_just_pressed("Selection 1"):
		active = false
		$Area/CollisionShape.disabled = true
		$Tween.interpolate_property($mButton, "translation:z",
				$mButton.transform.origin.z, $mButton.transform.origin.z - 0.055, 0.3,
				Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		$Tween.start()
		$Prompt.hide()

func _on_Area_body_entered(body):
	active = true
	$Prompt.show()

func _on_Area_body_exited(body):
	active = false
	$Prompt.hide()

func _on_Tween_tween_completed(object, key):
	emit_signal("button_pressed")
