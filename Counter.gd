extends Node

signal update
signal timer_update
signal log(log_message: LogMessage)
signal load_complete

const VERSION := "1.1"

var settings: Settings

var initialized := false

var items: Dictionary[String, int] = {}
var checks := 0
var total_checks := 0
var total_checks_counted_slots: Array[int] = []

var save: Save

var active_players: Array = []

var data_packages: Dictionary = {}
var players: Array = []
# relates game to a lookup table that relates item id to name
var item_lookup: Dictionary[String, Dictionary]
# relates game to a lookup table that relates location id to name
var location_lookup: Dictionary[String, Dictionary]

func _process(delta: float) -> void:
	if len(active_players) > 0:
		save.timer += delta
		timer_update.emit()


func _ready():
	tree_exiting.connect(on_quit)
	print("Loading settings and save...")
	on_load()
	
	print("Fetching Room Info")
	var socket := Socket.new(settings.url, settings.password)
	add_child(socket)
	await socket.fetch_room_info()
	for game in settings.games:
		print("Building lookup for {0}".format([game]))
		await build_lookup(game, socket)
	
	for game in settings.games:
		print("Fetching inventory for {0}".format([game]))
		var inventory := await socket.fetch_inventory(game, settings.games[game], data_packages[game]["checksum"])
		process_connected(inventory.connected_packet)
		if inventory.received_items_packet != {}:
			process_received_items(get_slot_id_from_name(settings.games[game]), inventory.received_items_packet)
	
	var watch_slot: String = settings.games.keys()[0]
	print("Watching for updates on {0}".format([watch_slot]))
	socket.watch_for_updates(watch_slot, settings.games[watch_slot], data_packages[watch_slot]["checksum"])
	socket.update_received.connect(update_received)
	update.emit()
	load_complete.emit()
	print("Load complete")


func build_lookup(game: String, socket: Socket):
	data_packages[game] = await socket.fetch_data_package(game)
	item_lookup[game] = {} as Dictionary[int, String]
	for item in data_packages[game]["item_name_to_id"]:
		item_lookup[game][int(data_packages[game]["item_name_to_id"][item])] = item
	
	location_lookup[game] = {} as Dictionary[int, String]
	for location in data_packages[game]["location_name_to_id"]:
		location_lookup[game][int(data_packages[game]["location_name_to_id"][location])] = location


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
		get_item(ui.receiving_player_id, ui.item_id)
		self.update.emit()
	
	log_update(update)


func get_item(slot_id: int, item_id: int):
	checks += 1
	var game_name := get_game_from_slot(slot_id)
	
	var item_name := get_item_name_from_id(slot_id, item_id)
	var item_code := "{0}::{1}".format([game_name, item_name])
	if item_code not in items:
		items[item_code] = 0
	
	items[item_code] += 1


func log_update(update: Socket.Update):
	var log_object := LogMessage.from_update(update)
	
	save.log.append(log_object)
	log.emit(log_object)


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


func get_color_for_slot(slot: String) -> Color:
	if slot in settings.custom_slot_colors:
		return settings.custom_slot_colors[slot]
	return settings.log_default_slot_color


func on_load():
	load_settings()
	load_save()


func on_quit():
	save.save()


func load_settings():
	var settings_data := Save.load_file("APSettings.json")
	if settings_data == {}:
		return
	
	settings = Settings.new(settings_data)


func load_save():
	save = Save.load()
	timer_update.emit()
