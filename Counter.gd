extends Node

signal update
signal timer_update
signal item_received(log_message: LogMessage)
signal load_complete

var settings: Settings

var initialized := false

var items: Dictionary[String, int] = {}
var checks := 0
var total_checks := 0
var total_checks_counted_slots: Array[int] = []

var timer := 0.0
var log: Array[LogMessage] = []

var active_players: Array = []

var data_packages: Dictionary = {}
var players: Array = []
# relates game to a lookup table that relates item id to name
var item_lookup: Dictionary[String, Dictionary]
# relates game to a lookup table that relates location id to name
var location_lookup: Dictionary[String, Dictionary]

func _process(delta: float) -> void:
	if len(active_players) > 0:
		timer += delta
		timer_update.emit()


func _ready():
	tree_exiting.connect(on_quit)
	on_load()
	
	var socket := Socket.new(settings.url, settings.password)
	add_child(socket)
	await socket.fetch_room_info()
	for game in settings.games:
		data_packages[game] = await socket.fetch_data_package(game)
		item_lookup[game] = {} as Dictionary[int, String]
		for item in data_packages[game]["item_name_to_id"]:
			item_lookup[game][int(data_packages[game]["item_name_to_id"][item])] = item
		
		location_lookup[game] = {} as Dictionary[int, String]
		for location in data_packages[game]["location_name_to_id"]:
			location_lookup[game][int(data_packages[game]["location_name_to_id"][location])] = location
	
	for game in settings.games:
		var inventory := await socket.fetch_inventory(game, settings.games[game], data_packages[game]["checksum"])
		process_connected(inventory.connected_packet)
		process_received_items(get_slot_id_from_name(settings.games[game]), inventory.received_items_packet)
	
	var watch_slot: String = settings.games.keys()[0]
	socket.watch_for_updates(watch_slot, settings.games[watch_slot], data_packages[watch_slot]["checksum"])
	socket.update_received.connect(update_received)
	update.emit()
	load_complete.emit()


func process_connected(packet):
	if int(packet["slot"]) in total_checks_counted_slots:
		return
	
	if players == []:
		players = packet["players"]
	
	total_checks_counted_slots.append(int(packet["slot"]))
	total_checks += len(packet["missing_locations"]) + len(packet["checked_locations"])


func process_received_items(slot_id: int, packet):
	for item in packet["items"]:
		if item["player"] <= 0: #Invalid player, not real item
			continue
		
		var item_id := int(item["item"])
		
		get_item(slot_id, item_id)


func update_received(update: Socket.Update):
	if update is Socket.Update_Player:
		var up := update as Socket.Update_Player
		if up.update_type == Socket.Update_Player.Player_Update_Type.Join:
			active_players.append(up.slot)
		elif up.update_type == Socket.Update_Player.Player_Update_Type.Part:
			active_players.erase(up.slot)
	
	if update is Socket.Update_Item:
		var ui := update as Socket.Update_Item
		log_item(ui.sending_player_id, ui.receiving_player_id, ui.item_id, ui.location_id)
		get_item(ui.receiving_player_id, ui.item_id)
		update.emit()


func get_item(slot_id: int, item_id: int):
	checks += 1
	var game_name := get_game_from_slot(slot_id)
	
	var item_name := get_item_name_from_id(slot_id, item_id)
	var item_code := "{0}::{1}".format([game_name, item_name])
	if item_code not in items:
		items[item_code] = 0
	
	items[item_code] += 1


func log_item(sending_player_id: int, receiving_player_id: int, item_id: int, location_id: int):
	var log_object := LogMessage.new(timer, sending_player_id, receiving_player_id, location_id, item_id)
	log.append(log_object)
	
	item_received.emit(log_object)


func get_player_name_from_id(id: int) -> String:
	for player in players:
		if int(player["slot"]) == id:
			return player["alias"]
	
	return "Someone"


func get_game_from_slot(id: int) -> String:
	for player in players:
		if int(player["slot"]) == id:
			var n: String = player["name"]
			for game in settings.games:
				if settings.games[game] == n:
					return game
	
	return ""


func get_slot_id_from_name(name: String) -> int:
	for player in players:
		if player["name"] == name:
			return int(player["slot"])
	
	return 0


func get_item_name_from_id(slot_id: int, item_id: int) -> String:
	var game := get_game_from_slot(slot_id)
	
	if item_id in item_lookup[game]:
		return item_lookup[game][item_id]
	
	return "Something"


func get_location_name_from_id(slot_id: int, location_id: int) -> String:
	var game := get_game_from_slot(slot_id)
	
	if location_id in location_lookup[game]:
		return location_lookup[game][location_id]
	
	return "Somewhere"


func get_item_count(code: String) -> int:
	if code in items:
		return items[code]
	
	return 0


func on_load():
	load_settings()
	load_save()


func on_quit():
	var log_data := []
	for log_message in log:
		log_data.append(log_message.to_json())

	# Save current timer to disk
	var save_data := {
		"timer": timer,
		"log": log_data
	}

	save_file("APCounter.json", save_data)


func load_file(file_name: String) -> Dictionary:
	var executable_path := OS.get_executable_path()
	var file_path := executable_path.get_base_dir() + "/" + file_name
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		return data
	
	return {}


func save_file(file_name: String, data: Dictionary) -> void:
	var executable_path := OS.get_executable_path()
	var file_path := executable_path.get_base_dir() + "/" + file_name
	var file := FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()


func load_settings():
	var settings_data := load_file("APSettings.json")
	if settings_data == null:
		return
	
	settings = Settings.new(settings_data)


func load_save():
	var save_data := load_file("APCounter.json")
	if save_data == null:
		return
		
	timer = save_data["timer"]
	var l = save_data["log"]
	
	for entry in l:
		var log_message := LogMessage.from_json(entry)
		log.append(log_message)
	
	timer_update.emit()
