class_name LayoutTool_PendingItems_Entry
extends PanelContainer

@export var label: Label
@export var normal_font: Font
@export var bold_font: Font
@export var h_align: HorizontalAlignment

@export var text := ""
@export var color := Color.WHITE
@export var bold := true

static func instantiate(text: String, color: Color, bold: bool, h_align := HorizontalAlignment.HORIZONTAL_ALIGNMENT_CENTER) -> LayoutTool_PendingItems_Entry:
	var entry: LayoutTool_PendingItems_Entry = \
		load("res://LayoutTool/PendingItems/LayoutTool_PendingItems_Entry.tscn").instantiate()
	entry.text = text
	entry.color = color
	entry.bold = bold
	entry.h_align = h_align
	return entry


func _ready() -> void:
	update_text()


func update_text():
	label.text = text
	label.label_settings.font_color = color
	label.label_settings.font = bold_font if bold else normal_font
	label.horizontal_alignment = h_align
