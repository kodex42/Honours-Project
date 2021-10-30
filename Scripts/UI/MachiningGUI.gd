extends Control

# Signal
signal machine_craft_requested(machine_name)

# Preloads
var machine_card = preload("res://Scenes/UI/MachiningPreviewCard.tscn")

# Exports
export var _machine_category = ""

# Nodes
onready var grid = $PanelContainer/MarginContainer/ScrollContainer/GridContainer

# Constants
const MACHINE_TYPES = {
	"Gatherer": [
		"Sawmill",
		"Excavator",
		"Pump",
		"Miner"
	],
	"Refining": [
		"Burner",
		"Smelter",
		"Market"
	],
	"Moving": [
		"Conveyer",
		"Inserter",
		"Accumulator"
	],
	"Powering": [
		"Power Tower",
		"Wheel",
		"Steam Engine",
		"Reactor"
	]
}

func _ready():
	if _machine_category != "":
		build_from_machine_type(_machine_category)

func build_from_machine_type(machine_type):
	# Clear
	for n in grid.get_children():
		n.queue_free()
	
	# Populate
	for m in MACHINE_TYPES[machine_type]:
		var card = machine_card.instance()
		card.build_from_machine(m)
		card.connect("machine_craft_requested", self, "on_craft_request_made")
		grid.add_child(card)

func on_craft_request_made(machine_name):
	emit_signal("machine_craft_requested", machine_name)
