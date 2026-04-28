class_name RunTimer
extends Label

func _ready():
	Counter.timer_update.connect(update_timer)
	Counter.log.connect(_on_log)
	update_timer()


func update_timer() -> void:
	text = Utils.seconds_to_hms(Counter.save.timer)


func _on_log(message: LogMessage):
	if message is LogMessage_SlotEvent and message.type == LogMessage_SlotEvent.TYPE.GOAL:
		if len(Counter.completed_games) == len(Counter.players):
			label_settings.font_color = Color.YELLOW_GREEN
