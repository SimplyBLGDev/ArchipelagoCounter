class_name LayoutTool_DeathlinkCounter
extends Label

@export var text_format: String = "{0}"
@export var slot: String
var count := 0

func _ready() -> void:
	Counter.log.connect(_on_log_update)
	
	await Counter.loaded()
	
	for log_entry in Counter.save.log:
		_on_log_update(log_entry)


func _on_log_update(log_entry: LogMessage) -> void:
	if log_entry is LogMessage_SlotEvent and log_entry.type == LogMessage_SlotEvent.TYPE.DEATHLINK:
		if slot == "" or Counter.get_slot_from_id(log_entry.slot) == slot:
			count += 1
			text = text_format.format([str(count)])
