extends Node

# State
var _applied = []
var _main = null

var machine_stat_mods = {
	"Miner" : {
		"Power" : 2,
		"Speed" : 1.25,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Excavator" : {
		"Power" : 2,
		"Speed" : 1.25,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Sawmill" : {
		"Power" : 2,
		"Speed" : 1.25,
		"Efficiency" : 1,
		"Range" : 1
	},
	"Pump" : {
		"Power" : 2,
		"Speed" : 1.25,
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
		"Power" : 300,
		"Speed" : 1,
		"Efficiency" : 1,
		"Range" : 4
	},
	"Reactor" : {
		"Power" : 1000000,
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
	elif "Ascension" in uname:
		ascend()
		return
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
	elif "Tool Balancing" in uname:
		return "Multiplies the power of Gathering Machines by 10\n(power determines how many resources are extracted each tick)"
	elif "Tool Sharpening" in uname:
		return "Adds 25% additional speed to Gathering Machines"
	elif "Precision Refining" in uname:
		return "Multiplies the power of Refining Machines by 10\n(power determines how many resources are created from ingredients each tick)"
	elif "Proficient Refining" in uname:
		return "Adds 25% additional speed to Refining Machines"
	elif "Intelligent Design" in uname:
		return "Multiplies the stack capacity of Inserters by 10\nand adds 200% item multiplication to Accumulators"
	elif "Overclocking" in uname:
		return "Adds 50% additional speed to Moving Machines"
	elif "Superconductive" in uname:
		return "Multiplies the power production of Powering Machines\nby 125% (this also increases power loss from Wheels due to entropy)"
	elif "Fresh Grease" in uname:
		return "Adds 25% additional speed to Powering Machines"
	elif "Ultimate" in uname:
		var desc = "Not written yet..."
		match uname.substr("Ultimate ".length()):
			"Gathering":
				desc = "Multiplies the power of Gathering Machines by 5"
			"Refining":
				desc = "Refining Machines no longer require or consume power"
			"Moving":
				desc = "Moving Machines reach maximum speed (400%)"
			"Powering":
				desc = "Powering Machines no longer lose power from entropy (except for the Wheel)"
		return desc
	elif "Ascension" in uname:
		return "Reset all of your progress, convert all machines, resources, and earned upgrades into Cash,\nand finally convert your Cash into Bytes! (Unlocks Byte upgrade tree [Not yet implemented])"
	else:
		return "Not written yet..."

func set_main_node(m):
	self._main = m

func ascend():
	var refund = Big.new(0)
	var machine_refund = {
		"wood": Big.new(0),
		"water": Big.new(0),
		"metal": Big.new(0),
		"coal": Big.new(0)
	}
	# Refund upgrades
	for u in self._applied:
		refund.plus(Constants.UPGRADE_COSTS["cash"][u])
	self._applied.clear()
	# Refund machines
	for m in get_tree().get_nodes_in_group("int_machine"):
		var half_cost = m.dismantle()
		for k in half_cost.keys():
			machine_refund[k].plus(half_cost[k])
	# Convert machine refunds into Cash
	refund.plus(machine_refund["wood"].divide(10))
	refund.plus(machine_refund["water"].divide(3))
	refund.plus(machine_refund["metal"].divide(2))
	refund.plus(machine_refund["coal"].divide(5))
	# Convert current resources into Cash
	var resources = self._main.player_remove_all_resources()
	refund.plus(Big.new(resources["wood"]).divide(10))
	refund.plus(Big.new(resources["water"]).divide(3))
	refund.plus(Big.new(resources["rock chunk"]).divide(10))
	refund.plus(Big.new(resources["coal"]).divide(5))
	refund.plus(Big.new(resources["metal"]).divide(2))
	refund.plus(Big.new(resources["cash"]))
	# Convert all cash to bytes
	var new_bytes = refund.divide("1e8").roundDown()
	_main.add_resource("byte", new_bytes)
	_main.get_node("World").get_node("Level").rebuild_level()
