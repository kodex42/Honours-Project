# Pseudo-Abstract class
# A special object is one that carries a state or can otherwise be packaged
# or rebuilt from a select few variables.
# Special objects must be able to package themselves and unpack themselves.
# Special objects must also only be interactable once, and thus must catch
# the interaction signal.

extends Spatial

# Signals
signal interaction

# State
var type : String
var description : String
var state # Flexible type
var activated = false

func _ready():
	init("Special Object", "This is a Special Object")

func init(t, d):
	connect("interaction", self, "_on_interaction")
	set_type(t)
	set_desc(d)

func interact():
	if not activated:
		emit_signal("interaction")
		activated = true

# Setters
func set_type(t):
	type = t

func set_desc(desc):
	description = desc

func set_state(s):
	state = s

 # Getters
func get_type():
	return type

func get_desc():
	return description

func get_state():
	return state

# Abstract functions
func pack():
	assert(false, "This function must be overridden by a child class.")

func unpack(obj):
	assert(false, "This function must be overridden by a child class.")

func _on_interaction():
	assert(false, "This function must be overridden by a child class.")

# Overrides
func _to_string():
	return type + " : " + description + " : state type = " + str(typeof(state))
