class_name LogMessage
extends Resource

var timestamp := -1.0
var sender_id := 0
var receiver_id := 0
var location_id := 0
var item_id := 0


static func from_json(json) -> LogMessage:
	var obj := LogMessage.new(json["time"], json["sender"], json["receiver"], json["location"], json["item"])
	return obj


func _init(_timestamp: float, _sender_id: int, _receiver_id: int, _location_id: int, _item_id: int):
	timestamp = _timestamp
	sender_id = _sender_id
	receiver_id = _receiver_id
	location_id = _location_id
	item_id = _item_id


func to_json() -> Dictionary:
	return {
		"time": timestamp,
		"sender": sender_id,
		"receiver": receiver_id,
		"location": location_id,
		"item": item_id
	}
