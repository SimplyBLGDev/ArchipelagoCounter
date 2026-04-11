class_name LayoutTool_Notes_SM64
extends LayoutTool_Notes

@export var code_edit: CodeEdit
@export var locations: Array[OptionButton]

static func instantiate(slot: String) -> LayoutTool_Notes_SM64:
	var instance: LayoutTool_Notes_SM64 = load("res://LayoutTool/Notes/SM64/LayoutTool_Notes_SM64.tscn").instantiate()
	instance.slot = slot
	return instance


func load_notes():
	if slot not in Counter.save.notes:
		Counter.save.notes[slot] = {
			"notes": "",
			"entrances": {}
		}
	
	code_edit.text = Counter.save.notes[slot]["notes"]
	
	for entrance in locations:
		if entrance.name not in Counter.save.notes[slot]["entrances"]:
			continue
		
		for entry in entrance.item_count:
			if Counter.save.notes[slot]["entrances"][entrance.name] == entrance.get_item_text(entry):
				entrance.select(entry)


func save_notes():
	Counter.save.notes[slot]["notes"] = code_edit.text
	
	for entrance in locations:
		if entrance.get_selected_id() == -1:
			continue
		
		Counter.save.notes[slot]["entrances"][entrance.name] = entrance.get_item_text(entrance.get_selected_id())
