class_name LayoutTool_Notes_MM
extends LayoutTool_Notes

@export var code_edit: CodeEdit
@export var shop_tracker: LayoutTool_Notes_ShopTracker

static func instantiate(slot: String) -> LayoutTool_Notes_MM:
	var instance: LayoutTool_Notes_MM = load("res://LayoutTool/Notes/MM/LayoutTool_Notes_MM.tscn").instantiate()
	instance.slot = slot
	return instance


func load_notes():
	var data: Dictionary = Counter.save.notes[slot]
	shop_tracker.generate_from_data(data["shops"])
	code_edit.text = data["notes"]


func save_notes():
	Counter.save.notes[slot] = {
		"notes": code_edit.text,
		"shops": shop_tracker.get_data()
	}
