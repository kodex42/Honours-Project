extends Control

# Signals
signal upgrade_details_pending(uname)

# State
var pending_upgrade = null

func _on_upgrade_selected(upgrade, uname):
	emit_signal("upgrade_details_pending", uname)
	pending_upgrade = upgrade

func _on_upgrade_unselected(upgrade):
	if pending_upgrade and pending_upgrade == upgrade:
		pending_upgrade = null
		emit_signal("upgrade_details_pending", "")
