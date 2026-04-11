class_name Save
extends Resource

const FILENAME := "APCounter.json"

var timer := 0.0
var log: Array[LogMessage] = []
var version: String = ProjectSettings.get_setting("application/config/version")
var starting_time := 0.0
var game_timer := {}
var notes := {}

static func save_file(file_name: String, data: Dictionary) -> void:
	var path := OS.get_executable_path().get_base_dir().path_join(file_name)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "", false))
		file.close()


static func load_file(file_name: String) -> Dictionary:
	var path := OS.get_executable_path().get_base_dir().path_join(file_name)
	var file := FileAccess.open(path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	
	return {}


static func load() -> Save:
	var save_data := load_file(FILENAME)
	if save_data == {}:
		return Save.new()
	
	var save := Save.new()
	save.timer = save_data.get("timer", 0.0)
	save.starting_time = save_data.get("starting_time", Time.get_unix_time_from_system())
	save.version = save_data.get("generated_version", ProjectSettings.get("application/config/version"))
	save.game_timer = save_data.get("game_timer", {})
	save.notes = save_data.get("notes", {})
	
	var log_data: Array = save_data.get("log", [])
	for log_entry in log_data:
		if log_entry == null:
			continue
		save.log.append(LogMessage.from_json(log_entry))
	
	return save

func save():
	var log_data := []
	for log_message in log:
		log_data.append(log_message.to_json())
	
	# Save current timer and timestamp to disk
	var save_data := {
		"timer": timer,
		"log": log_data,
		"starting_time": starting_time,
		"generated_version": version,
		"game_timer": game_timer,
		"notes": notes
	}
	
	save_file(FILENAME, save_data)
