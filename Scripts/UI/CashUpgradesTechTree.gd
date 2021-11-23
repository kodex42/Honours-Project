extends Control

# Signals
signal upgrade_details_pending(uname)
signal ascending()

# State
var pending_upgrade = null

func add_line(line):
	add_child(line)
	move_child(line, 0)

func reset():
	for c in get_children():
		if c.is_in_group("upgrade"):
			c.disabled = true
	$"One With Nature I".disabled = false
	$"Engineering 101 I".disabled = false
	$Ascension.disabled = false

func _on_upgrade_selected(upgrade, uname):
	emit_signal("upgrade_details_pending", uname)
	pending_upgrade = upgrade

func _on_upgrade_unselected(upgrade):
	if pending_upgrade and pending_upgrade == upgrade:
		pending_upgrade = null
		emit_signal("upgrade_details_pending", "")

func _on_Ascension_upgrade_applied():
	reset()
	emit_signal("ascending")
