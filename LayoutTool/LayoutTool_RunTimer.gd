class_name RunTimer
extends Label

func _ready():
	Counter.timer_update.connect(update_timer)
	update_timer()


func update_timer() -> void:
	text = Utils.seconds_to_hms(Counter.save.timer)
