class_name LayoutTool_ProgressPanel
extends MarginContainer

@export var color_rect: ColorRect
@export var game := ""

func _ready():
	Counter.timer_update.connect(update)
	
	await Counter.load_complete
	
	update()


func update():
	if game == "":
		update_checks(Counter.checks, Counter.total_checks)
	else:
		update_checks(Counter.game_checks[game], Counter.total_game_checks[game])


func update_checks(checks: int, total_checks: int):
	color_rect.material.set(&"shader_parameter/progress", float(checks) / float(total_checks))
