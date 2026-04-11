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
	var notes := LayoutTool_Notes_Generic.instantiate(name)
	notes.name = name
	add_child(notes)
