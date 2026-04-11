class_name LayoutTool_Notes_Generic
extends LayoutTool_Notes

@export var code_edit: CodeEdit

static func instantiate(slot: String) -> LayoutTool_Notes_Generic:
	var instance: LayoutTool_Notes_Generic = load("res://LayoutTool/Notes/Generic/LayoutTool_Notes_Generic.tscn").instantiate()
	instance.slot = slot
	return instance


func load_notes():
	if slot not in Counter.save.notes:
		Counter.save.notes[slot] = ""
	
	code_edit.text = Counter.save.notes[slot]


func _on_code_edit_text_changed() -> void:
	Counter.save.notes[slot] = code_edit.text
