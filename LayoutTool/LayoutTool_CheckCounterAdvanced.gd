class_name LayoutTool_CheckCounterAdvanced
extends LayoutTool_CheckCounter

func _ready():
	Counter.timer_update.connect(update)
	
	await Counter.load_complete
	
	update()


func update():
	var total_checks_digits := len(str(Counter.total_checks))
	var checks := str(Counter.checks).pad_zeros(total_checks_digits)
	var percent := str((float(Counter.checks) / float(Counter.total_checks)) * 100)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	var cpm := str(60.0 * (float(Counter.checks) / Counter.save.timer))
	cpm = cpm.pad_decimals(4)
	
	text = text_format.format([checks, Counter.total_checks, percent, str(cpm)])
