class_name LayoutTool_AnimatedLog_Entry
extends RichTextLabel

static func instantiate(text: String) -> LayoutTool_AnimatedLog_Entry:
	var instance: LayoutTool_AnimatedLog_Entry = load("res://LayoutTool/AnimatedLog/Entry/LayoutTool_AnimatedLog_Entry.tscn").instantiate()
	instance.text = text
	return instance
