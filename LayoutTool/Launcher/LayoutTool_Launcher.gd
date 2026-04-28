class_name LayoutTool_Launcher
extends HBoxContainer

@export var slot_select: OptionButton

var settings: Dictionary

func _ready():
	await Counter.loaded()
	settings = load_auto_launch_settings()
	populate_slots()


func load_auto_launch_settings() -> Dictionary:
	if FileAccess.file_exists(OS.get_executable_path().get_base_dir().path_join("APAutoLauncher.json")):
		return Save.load_file("APAutoLauncher.json")
	return {}


func populate_slots():
	while slot_select.item_count:
		slot_select.remove_item(0)
	
	if settings == {}:
		print("--APAutoLauncher.json not found, auto launcher disabled--")
		return
	
	for player in Counter.players:
		slot_select.add_item(player["name"])


func _on_button_pressed() -> void:
	Counter.flush_save()
	
	var selected_slot := slot_select.get_item_text(slot_select.selected)
	var actions := get_actions_for_slot(selected_slot)
	for action in actions:
		match action["action"]:
			"Command":
				powershell_command([action["command"]])
			
			"Launch":
				var file_path: String = action["path"]
				var file := file_path.get_file()
				var dir := file_path.get_base_dir()
				powershell_command([
					"cd " + dir,
					(".\\" if OS.get_name() == "Windows" else "./") + file
				])
			
			"Poptracker":
				var poptracker_path: String = settings["poptracker_path"]
				powershell_command([
					"cd " + poptracker_path.get_base_dir(),
					".{separator}{poptracker} --no-console --load-pack \"{pack}\" --pack-variant \"{variant}\"".format({
						"poptracker": poptracker_path.get_file(),
						"pack": action["pack"],
						"variant": action["variant"],
						"separator": "\\" if OS.get_name() == "Windows" else "/"
					})
				])
			
			"APFile":
				# Go to the directory of the file, cd to it, then open the file wit the specified extension
				var extension: String = action["extension"]
				var directory: String = action["directory"]
				# Look for the first file in the directory with the specified extension
				var dir := DirAccess.open(directory)
				var files := dir.get_files()
				var file := ""
				for _file in files:
					if _file.get_extension() == extension:
						file = _file
						break
				
				if file == "":
					print("No file with extension " + extension + " found in directory " + directory)
					return

				powershell_command([
					"cd " + directory,
					".{separator}{file}".format({
						"file": file,
						"separator": "\\" if OS.get_name() == "Windows" else "/"
					})
				])


func powershell_command(commands: Array[String]):
	match OS.get_name():
		"Windows":
			var final_command = ";".join(commands)
			OS.create_process("powershell.exe", ["-Command", final_command])
		_:
			var final_command = "&&".join(commands)
			OS.create_process("bash", ["-c", final_command])


func get_actions_for_slot(slot: String) -> Array:
	for _slot in settings["slots"]:
		if _slot["slot"] == slot:
			return _slot["actions"]
	
	return []
