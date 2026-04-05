class_name Settings
extends Resource

var url := ""
var password := ""
var games: Dictionary[String, String] = {}
var conditions: Dictionary = {}
var log_timestamp_color := Color("ffffff9b")
var log_item_color := Color("596bff")
var log_location_color := Color("00ff00")
var log_default_slot_color := Color("ff0000")
var custom_slot_colors: Dictionary[String, Color] = {}

func _init(data):
	url = data["url"]
	password = data["password"]

	for game in data["games"]:
		var game_name: String = game["game"]
		var slot_name: String = game["slot"]
		games[game_name] = slot_name
	
	conditions = data["conditions"]
	
	log_timestamp_color = Color(data["log_colors"]["timestamp"])
	log_item_color = Color(data["log_colors"]["item"])
	log_location_color = Color(data["log_colors"]["location"])
	log_default_slot_color = Color(data["log_colors"]["default_slot"])

	for slot_color in data["log_colors"]["slots"]:
		custom_slot_colors[slot_color] = Color(data["log_colors"]["slots"][slot_color])
