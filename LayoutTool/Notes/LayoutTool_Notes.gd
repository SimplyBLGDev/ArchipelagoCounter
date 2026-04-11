class_name LayoutTool_Notes
extends Control

static var NOTES := {
	"Super Mario 64": LayoutTool_Notes_SM64,
	"Ship of Harkinian": LayoutTool_Notes_OoT,
	"Majora's Mask Recompiled": LayoutTool_Notes_MM
}

var slot: String

static func instantiate(slot: String) -> LayoutTool_Notes:
	var instance: LayoutTool_Notes = load("res://LayoutTool/Notes/LayoutTool_Notes.tscn").instantiate()
	instance.slot = slot
	return instance


func _ready():
	await Counter.loaded()
	Counter.pre_save.connect(save_notes)
	load_notes()


func load_notes():
	pass


func save_notes():
	pass
