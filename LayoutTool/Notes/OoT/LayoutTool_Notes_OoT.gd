class_name LayoutTool_Notes_OoT
extends LayoutTool_Notes

@export var code_edit: CodeEdit
@export var shop_tracker: LayoutTool_Notes_ShopTracker

static func instantiate(slot: String) -> LayoutTool_Notes_OoT:
	var instance: LayoutTool_Notes_OoT = load("res://LayoutTool/Notes/OoT/LayoutTool_Notes_OoT.tscn").instantiate()
	instance.slot = slot
	return instance


func load_notes():
	if slot not in Counter.save.notes:
		Counter.save.notes[slot] = {
			"notes": "",
			"shops": {}
		}
	
	var data: Dictionary = Counter.save.notes[slot]
	shop_tracker.generate_from_data(data["shops"])
	code_edit.text = data["notes"]


func save_notes():
	Counter.save.notes[slot] = {
		"notes": code_edit.text,
		"shops": shop_tracker.get_data()
	}
