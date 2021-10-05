extends Control

# Signals
signal machine_craft_requested(machine_name)

# State
var mname

func build_from_machine(machine_name):
	mname = machine_name
	$MachineName.set_text(mname)
	$MachineIcon.texture = Constants.MACHINE_ICONS[machine_name]
	var desc = ""
	match mname:
		"Miner":
			desc = "This double-action auto-pickaxe is perfect for extracting Coal from Sooty Rocks, though the mystery of why it does not work on Shiny Rocks is mildly baffling."
		"Excavator":
			desc = "Grinds Shiny Rocks into pieces... maybe a little too well. The Rock Chunks it extracts will have to be refined into Metal."
		"Pump":
			desc = "With this machine you can finally collect Water! Though how it creates the buckets the water is held in is unknown."
		"Sawmill":
			desc = "Mow down trees even faster for better Wood gathering with this machine, and try not to stand in front of the blades."
		_:
			desc = "Description to be written later."
	$MachineDesc.set_text(desc)
	var costs = Constants.MACHINE_COSTS[machine_name]
	$GridContainer/WoodCost/HBoxContainer/Label.set_text(str(costs.wood))
	$GridContainer/WaterCost/HBoxContainer/Label.set_text(str(costs.water))
	$GridContainer/CoalCost/HBoxContainer/Label.set_text(str(costs.coal))
	$GridContainer/MetalCost/HBoxContainer/Label.set_text(str(costs.metal))

func _on_CraftButton_pressed():
	emit_signal("machine_craft_requested", self.mname)
