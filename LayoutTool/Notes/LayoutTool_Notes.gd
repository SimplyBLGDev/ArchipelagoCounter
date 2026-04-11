class_name LayoutTool_Notes
extends Control

var slot: String

static func instantiate(slot: String) -> LayoutTool_Notes:
	var instance: LayoutTool_Notes = load("res://LayoutTool/Notes/LayoutTool_Notes.tscn").instantiate()
	instance.slot = slot
	return instance


func _ready():
	await Counter.loaded()
	load_notes()


func load_notes():
	pass
