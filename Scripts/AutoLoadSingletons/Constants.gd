extends Node

const DEBUG = false
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
		"wood": "10000",
		"water": 0,
		"metal": 0,
		"coal": "1000"
	},
	"Burner": {
		"wood": 0,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Smelter": {
		"wood": 0,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
	"Market": {
		"wood": 0,
		"water": 0,
		"metal": 0,
		"coal": 0
	},
}
const MACHINE_INGREDIENTS = {
	"Miner": null,
	"Excavator": null,
	"Sawmill": null,
	"Pump": null,
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
	},
}
const MACHINE_ICONS = {
	"Miner" : preload("res://Data/Textures/UI/Machines/MinerIcon.png"),
	"Excavator" : preload("res://Data/Textures/UI/Machines/ExcavatorIcon.png"),
	"Market" : preload("res://Data/Textures/UI/Machines/MarketIcon.png"),
	"Burner" : preload("res://Data/Textures/UI/Machines/BurnerIcon.png"),
	"Pump" : preload("res://Data/Textures/UI/Machines/PumpIcon.png"),
	"Sawmill" : preload("res://Data/Textures/UI/Machines/SawmillIcon.png"),
	"Smelter" : preload("res://Data/Textures/UI/Machines/SmelterIcon.png")
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
