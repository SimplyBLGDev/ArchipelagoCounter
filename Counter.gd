extends Node

signal update
signal timer_update
signal item_received(log_message: LogMessage)
signal load_complete

@export var websocket_url = "ws://localhost:38281"

@export var games: Dictionary[String, String] = {
	"A Link to the Past": "BLGLttP",
	"Super Mario 64": "BLGSM64",
	"Majora's Mask Recompiled": "BLGMM",
	"The Minish Cap": "BLGMC",
	"Links Awakening DX": "BLGDX",
	"The Legend of Zelda - Oracle of Seasons": "BLGOoS",
	"Ship of Harkinian": "BLGOoT"
}
@export var conditions: Dictionary[String, Variant] = {
	"Links Awakening DX::Instrument Count": 6,
	"Ship of Harkinian::Dungeon Reward Count": 7,
	"Majora's Mask Recompiled::Remains Count": 3,
	"The Minish Cap::Swords": 5,
	"The Minish Cap::Elements": 3,
	"A Link to the Past::Triforce Count": 25,
	"The Legend of Zelda - Oracle of Seasons::Essences": 6,
}

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
	
	var socket := Socket.new(websocket_url)
	add_child(socket)
	await socket.fetch_room_info()
	for game in games:
		data_packages[game] = await socket.fetch_data_package(game)
		item_lookup[game] = {} as Dictionary[int, String]
		for item in data_packages[game]["item_name_to_id"]:
			item_lookup[game][int(data_packages[game]["item_name_to_id"][item])] = item
		
		location_lookup[game] = {} as Dictionary[int, String]
		for location in data_packages[game]["location_name_to_id"]:
			location_lookup[game][int(data_packages[game]["location_name_to_id"][location])] = location
	
	for game in games:
		var inventory := await socket.fetch_inventory(game, games[game], data_packages[game]["checksum"])
		process_connected(inventory.connected_packet)
		process_received_items(get_slot_id_from_name(games[game]), inventory.received_items_packet)
	
	var watch_slot: String = games.keys()[0]
	socket.watch_for_updates(watch_slot, games[watch_slot], data_packages[watch_slot]["checksum"])
	socket.update_received.connect(update_received)
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
	
	update.emit()


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
			for game in games:
				if games[game] == n:
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
	# Load timer from disk
	var executable_path := OS.get_executable_path()
	var file = FileAccess.open(executable_path.get_base_dir() + "/APCounter.json", FileAccess.READ)
	if file:
		var save_data = JSON.parse_string(file.get_as_text())
		
		timer = save_data["timer"]
		var l = save_data["log"]
		
		for entry in l:
			var log_message := LogMessage.from_json(entry)
			log.append(log_message)
		
		file.close()
	
	timer_update.emit()


func on_quit():
	var log_data := []
	for log_message in log:
		log_data.append(log_message.to_json())

	# Save current timer to disk
	var save_data := {
		"timer": timer,
		"log": log_data
	}

	var executable_path := OS.get_executable_path()
	var file = FileAccess.open(executable_path.get_base_dir() + "/APCounter.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
