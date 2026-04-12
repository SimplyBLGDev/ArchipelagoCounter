class_name LogMessage_SlotEvent
extends LogMessage

enum TYPE {
	UNKNOWN,
	JOIN,
	PART,
	DEATHLINK,
	GOAL,
	RELEASE,
	COLLECT,
}

const TYPE_TO_STRING: Dictionary[TYPE, String] = {
	TYPE.UNKNOWN: "unknown",
	TYPE.JOIN: "join",
	TYPE.PART: "part",
	TYPE.DEATHLINK: "deathlink",
	TYPE.GOAL: "goal",
	TYPE.RELEASE: "release",
	TYPE.COLLECT: "collect",
}

var type := TYPE.UNKNOWN
var unix_timestamp: float
var timestamp: float
var slot: int

static func from_json(json) -> LogMessage:
	var obj := LogMessage_SlotEvent.new(string_to_type(json["type"]), json["unixt"], json["time"], json["slot"])
	return obj


static func type_to_string(type: TYPE):
	return TYPE_TO_STRING[type]


static func string_to_type(string: String) -> TYPE:
	for key in TYPE_TO_STRING.keys():
		if TYPE_TO_STRING[key] == string:
			return key
	return TYPE.UNKNOWN


func _init(_type: TYPE, _unix_timestamp: float, _timestamp: float, _slot: int):
	type = _type
	unix_timestamp = _unix_timestamp
	timestamp = _timestamp
	slot = _slot


func to_json() -> Dictionary:
	return {
		"type": type_to_string(type),
		"unixt": unix_timestamp,
		"time": timestamp,
		"slot": slot,
	}
