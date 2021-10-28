extends HBoxContainer

# Signals
signal attempt_add_active_ingredient(res, amount)

# Nodes
onready var input_button = $InputButton
onready var amount_input = $InputButton/AmountLabel
onready var required_label = $VBoxContainer/RequiredLabel

# State
var machine_node
var ingredient
var amount_needed

func _ready():
	required_label.set_text(str(amount_needed))
	update()

func build(machine, res_name, amount):
	machine_node = machine
	ingredient = res_name
	amount_needed = amount

func update():
	amount_input.set_text(str(machine_node.get_active_ingredient(ingredient)))
	input_button.icon = Constants.RESOURCE_ICONS[ingredient]

func add_ingredients():
	emit_signal("attempt_add_active_ingredient", ingredient, amount_needed)

func _on_InputButton_pressed():
	add_ingredients()
