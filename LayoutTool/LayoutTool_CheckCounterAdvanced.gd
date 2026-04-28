class_name LayoutTool_CheckCounterAdvanced
extends LayoutTool_CheckCounter

@export var game := ""

func _ready():
	Counter.update.connect(update)
	
	await Counter.loaded()
	
	update()


func update():
	if game == "":
		update_text(Counter.checks, Counter.total_checks)
	else:
		update_text(Counter.game_checks[game], Counter.total_game_checks[game])


func update_text(checks: int, total_checks: int):
	var total_checks_digits := len(str(total_checks))
	var checks_str := str(checks).pad_zeros(total_checks_digits)
	var percent := str((float(checks) / float(total_checks)) * 100)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	var cpm := str(60.0 * (float(checks) / Counter.save.timer))
	cpm = cpm.pad_decimals(4)
	
	text = text_format.format([checks, total_checks, percent, str(cpm)])
