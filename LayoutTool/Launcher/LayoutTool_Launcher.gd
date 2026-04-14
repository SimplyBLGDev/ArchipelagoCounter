class_name LayoutTool_Launcher
extends HBoxContainer

@export var slot_select: OptionButton

var settings := load_auto_launch_settings()

func _ready():
	await Counter.loaded()
	populate_slots()


func load_auto_launch_settings() -> Dictionary:
	if FileAccess.file_exists("APAutoLauncher.json"):
		return Save.load_file("APAutoLauncher.json")
	return {}


func populate_slots():
	while slot_select.item_count:
		slot_select.remove_item(0)
	
	for player in Counter.players:
		slot_select.add_item(player["name"])


func _on_button_pressed() -> void:
	Counter.flush_save()
	
	var selected_slot := slot_select.get_item_text(slot_select.selected)
	var actions := get_actions_for_slot(selected_slot)
	for action in actions:
		match action["action"]:
			"Launch":
				OS.execute("powershell.exe", ["-Command", action["command"]])


func get_actions_for_slot(slot: String) -> Array:
	for _slot in settings["slots"]:
		if _slot["slot"] == slot:
			return _slot["actions"]
	
	return []
