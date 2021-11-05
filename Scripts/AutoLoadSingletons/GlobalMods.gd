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
	elif "Kings Yield" in uname: # Lower recharge time for shiny rocks
		resource_stat_mods["Shiny Rock"].recharge_rate *= 0.8
	elif "Black Diamonds" in uname: # Lower recharge time for sooty rocks
		resource_stat_mods["Sooty Rock"].recharge_rate *= 0.8
	elif "Renewable Resource" in uname: # Lower recharge time for water tiles
		resource_stat_mods["Water"].recharge_rate *= 0.8
	else:
		return
	_applied.append(uname)

func set_applied(upgrades):
	for u in upgrades:
		apply_upgrade(u)
	get_tree().call_group("upgrade", "check_applied")

func get_applied():
	return self._applied

func check_affordability(currency, uname):
	var cost = Constants.UPGRADE_COSTS[currency][uname]
	return _main.player_attempt_pay_resource(cost, currency)

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
		"max" : 1.0,				# More = higher max capacity
		"recharge_rate" : 1.0,		# Less = faster recharge
		"manual_gather_rate" : 1.0	# More = faster gathering
	},
	"Water" : {
		"max" : 1.0,
		"recharge_rate" : 1.0,
		"manual_gather_rate" : 1.0
	},
	"Sooty Rock" : {
		"max" : 1.0,
		"recharge_rate" : 1.0,
		"manual_gather_rate" : 1.0
	},
	"Shiny Rock" : {
		"max" : 1.0,
		"recharge_rate" : 1.0,
		"manual_gather_rate" : 1.0
	},
}

var player_mods = {
	"speed" : 1.25
}
