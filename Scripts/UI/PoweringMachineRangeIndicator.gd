extends MeshInstance

# Signals
signal created(global_pos, radius)

# Exports
export(bool) var is_preview = false

# State
var range_to_set = 1
var rad = 0.0
var machine = null

func _ready():
	if is_preview:
		$Sprite3D.hide()
	set_radius(range_to_set)
	emit_signal("created", global_transform.origin, self.rad)

func _process(delta):
	set_power(get_current_power())

func init(rRange, machine):
	self.range_to_set = rRange
	self.machine = machine
	if machine.body_name == "Power Tower":
		$Sprite3D.transform.origin.y = 4.5
	if machine.body_name == "Wheel":
		$Sprite3D.transform.origin.y = 3

func set_radius(rad):
	self.rad = rad*2
	update_radius()

func update_radius():
	self.mesh.top_radius = self.rad
	self.mesh.bottom_radius = self.rad

func set_power(amount):
	$ViewportText/VBoxContainer/Label.set_text("%d" % amount)

func get_current_power():
	if machine and machine.power_network:
		return machine.power_network.get_available_power()
	else:
		return 0.0
