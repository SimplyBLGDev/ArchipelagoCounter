class_name LogMessage_Item
extends LogMessage

var unix_timestamp := -1.0
var timestamp := -1.0
var sender_id := 0
var receiver_id := 0
var location_id := 0
var item_id := 0
var flags := 0

static func from_json(json) -> LogMessage:
	var obj := LogMessage_Item.new(json["unixt"], json["time"], json["sender"], json["receiver"], json["location"], json["item"], json["flags"])
	return obj


func _init(_unix_timestamp: float, _timestamp: float, _sender_id: int, _receiver_id: int, _location_id: int, _item_id: int, _flags: int):
	unix_timestamp = _unix_timestamp
	timestamp = _timestamp
	sender_id = _sender_id
	receiver_id = _receiver_id
	location_id = _location_id
	item_id = _item_id
	flags = _flags


func to_json() -> Dictionary:
	return {
		"type": "item",
		"time": timestamp,
		"unixt": unix_timestamp,
		"sender": sender_id,
		"receiver": receiver_id,
		"location": location_id,
		"item": item_id,
		"flags": flags,
	}
