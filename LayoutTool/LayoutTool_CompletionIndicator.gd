class_name LayoutTool_CompletionIndicator
extends TextureRect

@export var slot := ""

func _ready():
	Counter.update.connect(update)


func update():
	modulate.a = 1.0 if slot in Counter.completed_games else 0.0
