extends Node

const DEBUG = true
const BASE_MACHINE_STATS = {
	"Power" : 1.0,
	"Speed" : 1.0,
	"Efficiency" : 1.0,
	"Range" : 1
}
const MACHINE_COSTS = {
	"Miner": {
		"wood": 1000,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Excavator": {
		"wood": 10000,
		"water": 0,
		"metal": 0,
		"coal": 100
	},
	"Sawmill": {
		"wood": 10,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Pump": {
		"wood": 10000,
		"water": 0,
		"metal": 0,
		"coal": 1000
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
		"wood": 100,
		"water": 100,
		"metal": 100,
		"coal": 100
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
		"wood": 10,
		"water": 0,
		"metal": 0,
		"coal": 5
	},
	"Steam Engine": {
		"wood": 1000,
		"water": 250,
		"metal": 50,
		"coal": 100
	},
	"Reactor": {
		"wood": 10000,
		"water": 100,
		"metal": 500,
		"coal": 500
	},
	"Power Tower": {
		"wood": 10,
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
	"Steam Engine": null,
	"Reactor": null,
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
