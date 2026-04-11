class_name LayoutTool_Notes_Container
extends TabContainer

func _ready():
	await Counter.loaded()
	generate_tabs()


func generate_tabs():
	generate_tab("Generic")
	for slot in Counter.players:
		generate_tab(slot["name"])


func generate_tab(name: String):
	var slot_id := Counter.get_slot_id_from_name(name)
	var game := "" if slot_id == -1 else Counter.get_game_from_slot(slot_id)
	
	var notes: LayoutTool_Notes
	if game in LayoutTool_Notes.NOTES:
		notes = LayoutTool_Notes.NOTES[game].instantiate(name)
	else:
		notes = LayoutTool_Notes_Generic.instantiate(name)
	
	notes.name = name
	add_child(notes)
