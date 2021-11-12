extends Control

# Exports
export(NodePath) onready var _gui = get_node(_gui)
export(NodePath) onready var _phone_gui = get_node(_phone_gui)
export(NodePath) onready var _main = get_node(_main)

# Nodes
onready var details_cont = $UpgradeDetails
onready var currency_cont = $CashAndBytes
onready var cash_upgrade_tree = $Upgrades/CenterContainer/CashUpgradesTechTree

# State
var mode = "None"

func _ready():
	set_process(false)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		close()
	var mouse_pos = get_global_mouse_position()
	var offset = Vector2(16, 16)
	if mouse_pos.x > rect_size.x - details_cont.rect_size.x:
		details_cont.rect_position = Vector2(rect_size.x - details_cont.rect_size.x - offset.x, mouse_pos.y+offset.y)
	else:
		details_cont.rect_position = mouse_pos + offset

func create(tree_name):
	mode = tree_name
	update_currency()
	set_process(true)
	_gui.set_process(false)
	_gui.hide()
	_phone_gui.phone.disable()
	_phone_gui.set_process(false)
	_phone_gui.hide()
	GlobalControls.exclude()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	show()

func close():
	set_process(false)
	_gui.set_process(true)
	_gui.show()
	_phone_gui.phone.enable()
	_phone_gui.set_process(true)
	_phone_gui.show()
	GlobalControls.unexclude()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()

func update_currency():
	match mode:
		"cash":
			cash_upgrade_tree.show()
			cash_upgrade_tree.set_process(true)
			currency_cont.get_node("VBoxContainer/Cash").show()
			currency_cont.get_node("VBoxContainer/Bytes").hide()
			details_cont.get_node("VBoxContainer/cashCost").show()
			details_cont.get_node("VBoxContainer/byteCost").hide()
			currency_cont.get_node("VBoxContainer/Cash/Label").set_text(_main.get_resource_count("cash").toString())
		"byte":
			cash_upgrade_tree.hide()
			cash_upgrade_tree.set_process(false)
			currency_cont.get_node("VBoxContainer/Cash").hide()
			currency_cont.get_node("VBoxContainer/Bytes").show()
			details_cont.get_node("VBoxContainer/cashCost").hide()
			details_cont.get_node("VBoxContainer/byteCost").show()
			currency_cont.get_node("VBoxContainer/Bytes/Label").set_text(_main.get_resource_count("byte").toString())

func construct_details(uname):
	details_cont.get_node("VBoxContainer/UpgradeName").set_text(uname)
	details_cont.get_node("VBoxContainer/UpgradeDetails").set_text(GlobalMods.get_upgrade_desc(uname))
	details_cont.get_node("VBoxContainer/" + mode + "Cost/Label").set_text(str(Constants.UPGRADE_COSTS[mode][uname]))
	details_cont.show()
	details_cont.set_deferred("rect_size", details_cont.rect_min_size)

func _on_PhoneGUI_upgrades_window_opened(upgrade_type):
	self.create(upgrade_type)

func _on_CashUpgradesTechTree_upgrade_details_pending(uname):
	if is_processing():
		if uname != "":
			construct_details(uname)
		else:
			details_cont.hide()
			update_currency()
