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
			desc = "This double-action auto-pickaxe is perfect for extracting [Coal] from Sooty Rocks, though the mystery of why it does not work on Shiny Rocks is mildly baffling."
		"Excavator":
			desc = "Grinds Shiny Rocks into pieces... maybe a little too well. The [Rock Chunks] it extracts will have to be refined into [Metal] with another machine."
		"Pump":
			desc = "With this machine you can finally collect [Water]! Though how it creates the buckets the [Water] is held in is unknown."
		"Sawmill":
			desc = "Mow down trees even faster for better [Wood] gathering with this machine, and try not to stand in front of the blades."
		"Burner":
			desc = "An alternative to mining [Coal] is simply burning [Wood], and this machine does exactly that."
		"Smelter":
			desc = "Transform your boring old [Rock Chunks] into exciting [Metal] today!"
		"Market":
			desc = "No hedge funds or short-sellers here, use this to turn your [Wood], [Water], [Metal], and [Coal] into [Cash]!"
		"Conveyer":
			desc = "Cheap and reliable, the Conveyor moves a given stack of resources in a single direction."
		"Inserter":
			desc = "Moves resource stacks from one machine's inventory to another's."
		"Accumulator":
			desc = "Harnessing the power of [REDACTED], this machine transports whatever resource stacks are put into it directly into your inventory!"
		"Wheel":
			desc = "Uses the greenest of power sources to create power: your own legs! Your legs aren't actually green, are they? Interact with the Wheel and click the Board button to start running! This machine incurs a power cost equal to half its generation."
		"Power Tower":
			desc = "Connects power networks to share power generation and use between them! This machine incurs a constant cost of 1 power per tick."
		"Steam Engine":
			desc = "The Grand Dad of all engines, this baby can fit so much coal and water in it... to generate power that is. This machine incurs a constant cost of 5 power per tick."
		"Reactor":
			desc = "This machine uses [REDACTED] to [DATA EXPUNGED] making it the best Powering Machine you can get! This machine incurs a constant cost of 50 power per tick."
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
