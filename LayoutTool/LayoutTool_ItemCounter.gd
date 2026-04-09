class_name LayoutTool_ItemCounter
extends Label

@export var text_format := "{0}/{1}"
@export var regular_color: Color
@export var completed_color: Color
@export var items: Array[String]
@export var condition := ""

func _ready():
	Counter.update.connect(update)


func update():
	var count := 0
	var target_count: int = Counter.settings.conditions[condition]
	var target_count_digits := len(str(target_count))
	
	for item in items:
		count += Counter.get_item_count(item)
	
	text = text_format.format([str(count).pad_zeros(target_count_digits), target_count])
