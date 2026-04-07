class_name LogMessage_Join
extends LogMessage

var join: bool
var unix_timestamp: float
var timestamp: float
var slot: int

static func from_json(json) -> LogMessage:
	var _join : bool = json["type"] == "join"
	var obj := LogMessage_Join.new(json["unixt"], json["time"], json["slot"], _join)
	return obj


func _init(_unix_timestamp: float, _timestamp: float, _slot: int, _join: bool):
	unix_timestamp = _unix_timestamp
	timestamp = _timestamp
	slot = _slot
	join = _join


func to_json() -> Dictionary:
	return {
		"type": "join" if join else "part",
		"unixt": unix_timestamp,
		"time": timestamp,
		"slot": slot,
	}
