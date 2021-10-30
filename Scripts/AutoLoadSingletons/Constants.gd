extends Node

const DEBUG = true
const BASE_MACHINE_STATS = {
	"Power" : 1.0,
	"Speed" : 1.0,
	"Efficiency" : 1.0,
	"Range" : 1
}
const MACHINE_POWER_DRAW = {
	"Miner" : 30.0,
	"Excavator" : 30.0,
	"Pump" : 10.0,
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
		"water": 10,
		"metal": 0,
		"coal": 50
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
