extends Node

const DEBUG = true
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
		"wood": "1e6",
		"water": 0,
		"metal": 0,
		"coal": "1e5"
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
const MACHINE_ICONS = {
	"Miner" : preload("res://Data/Textures/UI/Machines/MinerIcon.png"),
	"Excavator" : preload("res://Data/Textures/UI/Machines/ExcavatorIcon.png"),
	"Market" : preload("res://Data/Textures/UI/Machines/MarketIcon.png"),
	"Burner" : preload("res://Data/Textures/UI/Machines/BurnerIcon.png"),
	"Pump" : preload("res://Data/Textures/UI/Machines/PumpIcon.png"),
	"Sawmill" : preload("res://Data/Textures/UI/Machines/SawmillIcon.png"),
	"Smelter" : preload("res://Data/Textures/UI/Machines/SmelterIcon.png")
}
