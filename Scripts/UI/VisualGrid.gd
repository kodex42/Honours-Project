extends MeshInstance

# Preloads
var range_indicator_scene = preload("res://Scenes/UI/PoweringMachineRangeIndicator.tscn")

# Nodes
onready var range_indicators = $RangeIndicators

# State
var children = {}

func _on_InteractablesGrid_powering_machine_added(machine : StaticBody, pos):
	var indicator = range_indicator_scene.instance()
	indicator.init(machine.machine_stats.Range, machine.power_network, machine.body_name)
	indicator.global_transform.origin = pos
	children[machine.name] = indicator
	range_indicators.add_child(indicator)
	machine.connect("removed", self, "_on_machine_removed")

func _on_machine_removed(machineName):
	children[machineName].queue_free()
	children.erase(machineName)
