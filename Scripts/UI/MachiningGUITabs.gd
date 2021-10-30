extends TabContainer

# Signals
signal machine_craft_requested(machine_name)

func _on_Gathering_machine_craft_requested(machine_name):
	emit_signal("machine_craft_requested", machine_name)

func _on_Refining_machine_craft_requested(machine_name):
	emit_signal("machine_craft_requested", machine_name)

func _on_Moving_machine_craft_requested(machine_name):
	emit_signal("machine_craft_requested", machine_name)

func _on_Powering_machine_craft_requested(machine_name):
	emit_signal("machine_craft_requested", machine_name)
