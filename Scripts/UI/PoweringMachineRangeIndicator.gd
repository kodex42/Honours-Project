extends Spatial

# Nodes
onready var torus = get_node("CSGTorus")

# Exportd
export(bool) var is_preview = false

# State
var range_to_set = 1
var tick = 0.0
var tick_speed = 0.1
var power_network : PowerNetwork

func _ready():
	if is_preview:
		$Sprite3D.hide()
	set_radius(range_to_set)

func _process(delta):
	if not is_preview:
		tick += delta
		if tick >= tick_speed:
			tick -= tick_speed
			set_power(get_current_power())

func init(rRange, pnet : PowerNetwork):
	self.range_to_set = rRange
	self.power_network = pnet

func set_radius(rad):
	torus.outer_radius = rad*2 + 0.25
	torus.inner_radius = rad*2

func set_power(amount):
	$Sprite3D/ViewportText/VBoxContainer/Label.set_text("%.2f" % amount)

func get_current_power():
	if power_network:
		return power_network.get_available_power()
	else:
		return 0.0
