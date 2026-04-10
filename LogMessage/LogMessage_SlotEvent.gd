class_name LogMessage_SlotEvent
extends LogMessage

var type := "Generic"
var unix_timestamp: float
var timestamp: float
var slot: int

static func from_json(json) -> LogMessage:
	var obj := LogMessage_SlotEvent.new(json["type"], json["unixt"], json["time"], json["slot"])
	return obj


func _init(_type: String, _unix_timestamp: float, _timestamp: float, _slot: int):
	type = _type
	unix_timestamp = _unix_timestamp
	timestamp = _timestamp
	slot = _slot


func to_json() -> Dictionary:
	return {
		"type": type,
		"unixt": unix_timestamp,
		"time": timestamp,
		"slot": slot,
	}
