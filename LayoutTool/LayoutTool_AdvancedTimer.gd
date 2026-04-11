class_name LayoutTool_AdvancedTimer
extends Label

@export_multiline var text_format := "{0} ({1}%)"
@export var game := ""

func _ready():
	Counter.timer_update.connect(update)
	await Counter.loaded()
	update()


func update():
	var time: float = Counter.save.game_timer[game] if game in Counter.save.game_timer else 0.0
	
	var percentage := time / Counter.save.timer if Counter.save.timer > 0.0 else 0.0
	percentage *= 100
	var percent := str(percentage)
	percent = percent.pad_zeros(2)
	percent = percent.pad_decimals(2)
	
	text = text_format.format([Utils.seconds_to_hms(time), percent])
