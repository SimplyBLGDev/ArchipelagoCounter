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
var overrides: Dictionary = {}
var archipelago_connection_data: Dictionary = {}

func _init(data):
	url = data["archipelago_connection_data"]["url"]
	password = data["archipelago_connection_data"]["password"]
	
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
	
	archipelago_connection_data = data["archipelago_connection_data"]
	archipelago_connection_data["version"]["build"] = int(archipelago_connection_data["version"]["build"])
	archipelago_connection_data["version"]["major"] = int(archipelago_connection_data["version"]["major"])
	archipelago_connection_data["version"]["minor"] = int(archipelago_connection_data["version"]["minor"])
	archipelago_connection_data["version"]["class"] = "Version"
	
	if data.has("overrides"):
		overrides = data["overrides"]


func get_override_settings_for_game(game: String) -> Dictionary:
	if overrides == {}:
		return {}
	
	if not overrides.has("games"):
		return {}

	if game in overrides["games"]:
		return overrides["games"][game]
	
	return {}


func get_override_data_package_file_for_game(game: String) -> Dictionary:
	var override_settings := get_override_settings_for_game(game)
	
	if override_settings == {}:
		return {}
	
	if not override_settings.has("data_package_file"):
		return {}
	
	var path: String = override_settings["data_package_file"]
	if path == "":
		return {}
	
	path = OS.get_executable_path().get_base_dir().path_join(path)
	
	if not FileAccess.file_exists(path):
		print("Data package file specified in override settings does not exist: " + path)
		return {}
	
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data

	return {}


func get_excluded_locations_for_game(game: String) -> Array:
	var override_settings := get_override_settings_for_game(game)
	
	if override_settings == {}:
		return []
	
	if not override_settings.has("excluded_locations"):
		return []
	
	return override_settings["excluded_locations"]
