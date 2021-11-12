extends Node

# State
var _applied = []
var _main = null

func apply_upgrade(uname):
#	print("Applying upgrade " + name)
	# Many if, else statements incoming!
	if "One With Nature" in uname: # Double capacity and manual gather speed
		for r in resource_stat_mods.keys():
			resource_stat_mods[r].max *= 2
			resource_stat_mods[r].manual_gather_rate *= 1.75
	elif "Professional Arborist" in uname: # Lower recharge time for trees
		resource_stat_mods["Tree"].recharge_rate *= 0.8
		resource_stat_mods["Tree"].max *= 100
	elif "Kings Yield" in uname: # Lower recharge time for shiny rocks
		resource_stat_mods["Shiny Rock"].recharge_rate *= 0.8
		resource_stat_mods["Tree"].max *= 100
	elif "Black Diamonds" in uname: # Lower recharge time for sooty rocks
		resource_stat_mods["Sooty Rock"].recharge_rate *= 0.8
		resource_stat_mods["Tree"].max *= 100
	elif "Renewable Resource" in uname: # Lower recharge time for water tiles
		resource_stat_mods["Water"].recharge_rate *= 0.8
		resource_stat_mods["Tree"].max *= 100
	elif "Engineering 101" in uname: # Increased power for machines
		match uname.substr(len("Engineering 101 ")):
			"I":
				machine_stat_mods["Miner"].Power *= 5
				machine_stat_mods["Excavator"].Power *= 5
				machine_stat_mods["Sawmill"].Power *= 5
				machine_stat_mods["Pump"].Power *= 5
			"II":
				machine_stat_mods["Burner"].Power *= 5
				machine_stat_mods["Smelter"].Power *= 5
				machine_stat_mods["Market"].Power *= 5
			"III":
				machine_stat_mods["Conveyer"].Power *= 2
				machine_stat_mods["Inserter"].Power *= 2
				machine_stat_mods["Accumulator"].Power *= 2
			"IV":
				machine_stat_mods["Wheel"].Power *= 1.25
				machine_stat_mods["Steam Engine"].Power *= 1.25
				machine_stat_mods["Reactor"].Power *= 1.25
				machine_stat_mods["Power Tower"].Power *= 1.25
	elif "Tool Balancing" in uname: # Vastly increased power for gathering machines
		machine_stat_mods["Miner"].Power *= 10
		machine_stat_mods["Excavator"].Power *= 10
		machine_stat_mods["Sawmill"].Power *= 10
		machine_stat_mods["Pump"].Power *= 10
	elif "Tool Sharpening" in uname: # Increased speed for gathering machines
		machine_stat_mods["Miner"].Speed += 0.25
		machine_stat_mods["Excavator"].Speed += 0.25
		machine_stat_mods["Sawmill"].Speed += 0.25
		machine_stat_mods["Pump"].Speed += 0.25
	elif "Precision Refining" in uname: # Vastly increased power for refining machines
		machine_stat_mods["Burner"].Power *= 10
		machine_stat_mods["Smelter"].Power *= 10
		machine_stat_mods["Market"].Power *= 10
	elif "Proficient Refining" in uname: # Increased speed for refining machines
		machine_stat_mods["Burner"].Speed += 0.25
		machine_stat_mods["Smelter"].Speed += 0.25
		machine_stat_mods["Market"].Speed += 0.25
	elif "Intelligent Design" in uname: # Vastly increased power for moving machines
		machine_stat_mods["Conveyer"].Power *= 10
		machine_stat_mods["Inserter"].Power *= 10
		machine_stat_mods["Accumulator"].Power += 2
	elif "Overclocking" in uname: # Increased speed for moving machines
		machine_stat_mods["Conveyer"].Speed += 0.5
		machine_stat_mods["Inserter"].Speed += 0.5
		machine_stat_mods["Accumulator"].Speed += 0.5
	elif "Superconductive" in uname: # Vastly increased power for powering machines
		machine_stat_mods["Wheel"].Power *= 1.25
		machine_stat_mods["Steam Engine"].Power *= 1.25
		machine_stat_mods["Reactor"].Power *= 1.25
		machine_stat_mods["Power Tower"].Power *= 1.25
	elif "Fresh Grease" in uname: # Increased speed for powering machines
		machine_stat_mods["Wheel"].Speed += 0.25
		machine_stat_mods["Steam Engine"].Speed += 0.25
		machine_stat_mods["Reactor"].Speed += 0.25
		machine_stat_mods["Power Tower"].Speed += 0.25
	elif "Ultimate" in uname: # Ultimate upgrades
		match uname.substr("Ultimate ".length()):
			"Gathering": # 5 times Power!
				machine_stat_mods["Miner"].Power *= 5
				machine_stat_mods["Excavator"].Power *= 5
				machine_stat_mods["Sawmill"].Power *= 5
				machine_stat_mods["Pump"].Power *= 5
			"Refining": # No power consumption!
				machine_stat_mods["Burner"].Efficiency = 0
				machine_stat_mods["Smelter"].Efficiency = 0
				machine_stat_mods["Market"].Efficiency = 0
			"Moving": # Ludicrous Speed!
				machine_stat_mods["Conveyer"].Speed += 2
				machine_stat_mods["Inserter"].Speed += 2
				machine_stat_mods["Accumulator"].Speed += 2
			"Powering": # No entropy! (Except for Wheel)
				machine_stat_mods["Steam Engine"].Efficiency = 0
				machine_stat_mods["Reactor"].Efficiency = 0
				machine_stat_mods["Power Tower"].Efficiency = 0
	else:
		return
	_applied.append(uname)
	get_tree().call_group("upgrade", "check_applied")

func set_applied(upgrades):
	for u in upgrades:
		apply_upgrade(u)

func get_applied():
	return self._applied

func check_affordability(currency, uname):
	var cost = Constants.UPGRADE_COSTS[currency][uname]
	return _main.player_attempt_pay_resource(cost, currency)

func get_upgrade_desc(uname):
	if "One With Nature" in uname: # Double capacity and manual gather speed
		return "Doubles maximum resource capacity and increases manual gather rate\nby 75% for all resource tiles."
	elif "Professional Arborist" in uname: # Lower recharge time for trees
		return "Increases Tree resource regeneration speed by 20% and max [Wood]\ncapacity by 100 times"
	elif "Kings Yield" in uname: # Lower recharge time for shiny rocks
		return "Increases Shiny Rock resource regeneration speed by 20% and max \n[Shiny Rock] capacity by 100 times"
	elif "Black Diamonds" in uname: # Lower recharge time for sooty rocks
		return "Increases Sooty Rock resource regeneration speed by 20% and max \n[Coal] capacity by 100 times"
	elif "Renewable Resource" in uname: # Lower recharge time for water tiles
		return "Increases Water Tile resource regeneration speed by 20% and max \n[Water] capacity by 100 times"
	elif "Engineering 101" in uname: # Increased power for machines
		var desc = "Increases the Power of %s machines by %d%%"
		var mtype = ""
		var inc = 0
		match uname.substr("Engineering 101 ".length()):
			"I":
				mtype = "Gathering"
				inc = 400
			"II":
				mtype = "Refining"
				inc = 400
			"III":
				mtype = "Moving"
				inc = 100
			"IV":
				mtype = "Powering"
				inc = 25
		return desc % [mtype, inc]
	else:
		return "Not written yet..."

func set_main_node(m):
	self._main = m

var machine_stat_mods = {
	"Miner" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Excavator" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Sawmill" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Pump" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Burner" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Smelter" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Market" : {
		"Power" : 2,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Inserter" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Conveyer" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Accumulator" : {
		"Power" : 1,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Wheel" : {
		"Power" : 150,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 3.5
	},
	"Steam Engine" : {
		"Power" : 750,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 4
	},
	"Reactor" : {
		"Power" : 10000000,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 8
	},
	"Power Tower" : {
		"Power" : 0,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 5
	},
}

var resource_stat_mods = {
	"Tree" : {
		"max" : 100,				# More = higher max capacity
		"recharge_rate" : 0.5,		# Less = faster recharge
		"manual_gather_rate" : 0.5	# More = faster gathering
	},
	"Water" : {
		"max" : 100,
		"recharge_rate" : 0.5,
		"manual_gather_rate" : 0.5
	},
	"Sooty Rock" : {
		"max" : 100,
		"recharge_rate" : 0.5,
		"manual_gather_rate" : 0.5
	},
	"Shiny Rock" : {
		"max" : 100,
		"recharge_rate" : 0.5,
		"manual_gather_rate" : 0.5
	},
}

var player_mods = {
	"speed" : 1.25
}
