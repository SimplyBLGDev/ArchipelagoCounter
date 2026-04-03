class_name LayoutTool_CheckCounter
extends Label

@export_multiline("Format") var text_format := "{0}/{1}"

func _ready():
	Counter.update.connect(update)


func update():
	var total_checks_digits := len(str(Counter.total_checks))
	var checks := str(Counter.checks).pad_zeros(total_checks_digits)
	text = text_format.format([checks, Counter.total_checks])
