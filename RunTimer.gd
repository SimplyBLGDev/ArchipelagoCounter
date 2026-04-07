class_name RunTimer
extends Label

func _ready():
	Counter.timer_update.connect(update_timer)
	update_timer()


func update_timer() -> void:
	text = seconds_to_hms(Counter.save.timer)


func seconds_to_hms(seconds: float) -> String:
	var hours = floor(seconds / 3600)
	var minutes = floor((fposmod(seconds, 3600)) / 60)
	var secs = fposmod(seconds, 60)
	
	return "%02d:%02d:%02d" % [hours, minutes, secs]
