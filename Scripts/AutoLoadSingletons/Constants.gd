extends Node

const DEBUG = true
const BASE_MACHINE_STATS = {
	"Power" : 1.0,		# 1.0 - inf, more = more items / power
	"Speed" : 1.0,		# 1.0 - inf, more = faster ticks and animations for machines
	"Efficiency" : 1.0,	# 0.0 - 1.0, less = less power consumption
	"Range" : 1			# 1 - 50, more = more resource tiles consumed by gathering machines and more tiles powered by powering machines
}
const MACHINE_POWER_DRAW = {
	"Miner" : 20.0,
	"Excavator" : 30.0,
	"Pump" : 30.0,
	"Sawmill" : 10.0,
	"Burner" : 5.0,
	"Smelter" : 25.0,
	"Market" : 100.0,
	"Inserter" : 1.0,
	"Conveyer" : 0.0,
	"Accumulator" : 50.0,
	"Power Tower" : 0.0,
	"Wheel" : 0.0,
	"Steam Engine" : 0.0,
	"Reactor" : 0.0
}
const MACHINE_COSTS = {
	"Miner": {
		"wood": 100,
		"water": 0,
		"metal": 0,
		"coal": 5
	},
	"Excavator": {
		"wood": 1000,
		"water": 75,
		"metal": 0,
		"coal": 500
	},
	"Sawmill": {
		"wood": 10,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Pump": {
		"wood": 500,
		"water": 0,
		"metal": 0,
		"coal": 250
	},
	"Burner": {
		"wood": 10,
		"water": 25,
		"metal": 0,
		"coal": 50
	},
	"Smelter": {
		"wood": 10,
		"water": 50,
		"metal": 0,
		"coal": 25
	},
	"Market": {
		"wood": 1000,
		"water": 1000,
		"metal": 1000,
		"coal": 1000
	},
	"Conveyer": {
		"wood": 1,
		"water": 1,
		"metal": 1,
		"coal": 1
	},
	"Inserter": {
		"wood": 10,
		"water": 10,
		"metal": 10,
		"coal": 10
	},
	"Accumulator": {
		"wood": 0,
		"water": 0,
		"metal": 500,
		"coal": 0
	},
	"Wheel": {
		"wood": 25,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Steam Engine": {
		"wood": 10,
		"water": 25,
		"metal": 5,
		"coal": 25
	},
	"Reactor": {
		"wood": "1e6",
		"water": "1e6",
		"metal": "1e7",
		"coal": "1e5"
	},
	"Power Tower": {
		"wood": 20,
		"water": 0,
		"metal": 10,
		"coal": 0
	}
}
const MACHINE_INGREDIENTS = {
	"Miner": null,
	"Excavator": null,
	"Sawmill": null,
	"Pump": null,
	"Conveyer": null,
	"Inserter": null,
	"Accumulator": null,
	"Power Tower": null,
	"Wheel": null,
	"Steam Engine": {
		"coal" : 5,
		"water" : 5
	},
	"Reactor": {
		"coal" : 10000,
		"metal" : 50000,
		"water" : 5000
	},
	"Burner": {
		"wood": 2,
	},
	"Smelter": {
		"rock chunk": 1,
		"coal": 1
	},
	"Market": {
		"wood": 10,
		"water": 3,
		"metal": 2,
		"coal": 5
	}
}
const MACHINE_ICONS = {
	"Miner" : preload("res://Data/Textures/UI/Machines/MinerIcon.png"),
	"Excavator" : preload("res://Data/Textures/UI/Machines/ExcavatorIcon.png"),
	"Market" : preload("res://Data/Textures/UI/Machines/MarketIcon.png"),
	"Burner" : preload("res://Data/Textures/UI/Machines/BurnerIcon.png"),
	"Pump" : preload("res://Data/Textures/UI/Machines/PumpIcon.png"),
	"Sawmill" : preload("res://Data/Textures/UI/Machines/SawmillIcon.png"),
	"Smelter" : preload("res://Data/Textures/UI/Machines/SmelterIcon.png"),
	"Conveyer" : preload("res://Data/Textures/UI/Machines/ConveyerIcon.png"),
	"Inserter" : preload("res://Data/Textures/UI/Machines/InserterIcon.png"),
	"Accumulator" : preload("res://Data/Textures/UI/Machines/AccumulatorIcon.png"),
	"Wheel" : preload("res://Data/Textures/UI/Machines/WheelIcon.png"),
	"Steam Engine" : preload("res://Data/Textures/UI/Machines/SteamEngineIcon.png"),
	"Reactor" : preload("res://Data/Textures/UI/Machines/ReactorIcon.png"),
	"Power Tower" : preload("res://Data/Textures/UI/Machines/PowerTowerIcon.png")
}
const RESOURCE_ICONS = {
	"wood" : preload("res://Data/Textures/Resources/wood.png"),
	"water" : preload("res://Data/Textures/Resources/water.png"),
	"coal" : preload("res://Data/Textures/Resources/coal.png"),
	"rock chunk" : preload("res://Data/Textures/Resources/rock_chunk.png"),
	"metal" : preload("res://Data/Textures/Resources/metal.png"),
	"cash" : preload("res://Data/Textures/Resources/cash.png"),
	"byte" : preload("res://Data/Textures/Resources/byte.png")
}
const UPGRADE_COSTS = {
	"cash": {
		"One With Nature I" : 10,
		"One With Nature II" : 20,
		"One With Nature III" : 40,
		"One With Nature IV" : 80,
		"Professional Arborist I" : 100,
		"Professional Arborist II" : 1000,
		"Professional Arborist III" : 10000,
		"Professional Arborist IV" : 100000,
		"Kings Yield I" : 200,
		"Kings Yield II" : 2000,
		"Kings Yield III" : 20000,
		"Kings Yield IV" : 200000,
		"Black Diamonds I" : 400,
		"Black Diamonds II" : 4000,
		"Black Diamonds III" : 40000,
		"Black Diamonds IV" : 400000,
		"Renewable Resource I" : 800,
		"Renewable Resource II" : 8000,
		"Renewable Resource III" : 80000,
		"Renewable Resource IV" : 800000,
		"Engineering 101 I" : 500,
		"Engineering 101 II" : 1000,
		"Engineering 101 III" : 5000,
		"Engineering 101 IV" : 10000,
		"Superconductive I" : 20000,
		"Superconductive II" : 40000,
		"Superconductive III" : 80000,
		"Superconductive IV" : 160000,
		"Fresh Grease I" : 20000,
		"Fresh Grease II" : 40000,
		"Fresh Grease III" : 80000,
		"Fresh Grease IV" : 160000,
		"Ultimate Powering" : "1e7",
		"Intelligent Design I" : 10000,
		"Intelligent Design II" : 20000,
		"Intelligent Design III" : 40000,
		"Intelligent Design IV" : 80000,
		"Overclocking I" : 10000,
		"Overclocking II" : 20000,
		"Overclocking III" : 40000,
		"Overclocking IV" : 80000,
		"Ultimate Moving" : "1e7",
		"Precision Refining I" : 2000,
		"Precision Refining II" : 4000,
		"Precision Refining III" : 8000,
		"Precision Refining IV" : 16000,
		"Proficient Refining I" : 2000,
		"Proficient Refining II" : 4000,
		"Proficient Refining III" : 8000,
		"Proficient Refining IV" : 16000,
		"Ultimate Refining" : "1e7",
		"Tool Sharpening I" : 1000,
		"Tool Sharpening II" : 2000,
		"Tool Sharpening III" : 4000,
		"Tool Sharpening IV" : 8000,
		"Tool Balancing I" : 1000,
		"Tool Balancing II" : 2000,
		"Tool Balancing III" : 4000,
		"Tool Balancing IV" : 8000,
		"Ultimate Gathering" : "1e7"
	},
	"byte": {
		
	}
}
