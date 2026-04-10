class_name Socket
extends Node

const CONNECTION_COMMAND := '[{"cmd":"Connect","password":"{password}","game":"{game}","name":"{slot}","uuid":"{uuid}","version":{version},"items_handling":{items_handling},"tags":["AP","Tracker","TextOnly"],"slot_data":true}]'

signal updates_received(updates: Array[Update])

var socket = WebSocketPeer.new()
var url := ""
var password := ""
var room_info := {}
var pending_packets := []

func _init(url: String, password: String) -> void:
	self.url = url
	self.password = password


func _ready():
	set_process(false)


func fetch_room_info():
	var err = socket.connect_to_url(url)
	if err == OK:
		print("Connecting to %s..." % url)
	else:
		push_error("Unable to connect.")
		return
	
	var packet = await await_packet(socket)
	room_info = packet[0]


func close():
	socket.close()
	queue_free()


func await_packet(socket: WebSocketPeer):
	while true:
		socket.poll()
		var state := socket.get_ready_state()
		
		if state == WebSocketPeer.STATE_OPEN:
			while socket.get_available_packet_count():
				var packet = socket.get_packet()
				if socket.was_string_packet():
					var packet_text = packet.get_string_from_utf8()
					return JSON.parse_string(packet_text)
		
		elif state == WebSocketPeer.STATE_CLOSED:
			return null
		
		await get_tree().physics_frame


func await_cmd_packet(socket: WebSocketPeer, cmd: String):
	while true:
		var packet_pack = await await_packet(socket)
		for packet in packet_pack:
			if packet["cmd"] == cmd:
				return packet


func fetch_data_package(game):
	socket.send_text('[{"cmd":"GetDataPackage","games":["' + game + '"]}]')
	
	var data_package = await await_cmd_packet(socket, "DataPackage")
	return data_package["data"]["games"][game]


func fetch_inventory(game: String, slot: String, uuid: String) -> Game_Inventory:
	var inventory := Game_Inventory.new()
	var game_socket := WebSocketPeer.new()
	var err = game_socket.connect_to_url(url)
	
	if err != OK:
		push_error("Unable to connect.")
		return
	
	await await_cmd_packet(game_socket, "RoomInfo")

	var command := CONNECTION_COMMAND.format({
		"password": password,
		"game": game,
		"slot": slot,
		"uuid": uuid,
		"items_handling": "7",
		"version": JSON.stringify(Counter.settings.archipelago_connection_data.version)
	})
	game_socket.send_text(command)
	
	var packet_pack = await await_packet(game_socket)
	for packet in packet_pack:
		match packet["cmd"]:
			"Connected":
				inventory.connected_packet = packet
			"ReceivedItems":
				inventory.received_items_packet = packet
	
	return inventory


func watch_for_updates(game: String, slot: String, uuid: String):
	set_process(true) # Start polling the socket in _process

	var command := CONNECTION_COMMAND.format({
		"password": password,
		"game": game,
		"slot": slot,
		"uuid": uuid,
		"items_handling": "0",
		"version": JSON.stringify(Counter.settings.archipelago_connection_data.version)
	})
	socket.send_text(command)
	
	while true:
		while len(pending_packets) == 0:
			await get_tree().physics_frame
		
		var updates: Array[Update] = []
		while len(pending_packets) > 0:
			var packet_pack = pending_packets.pop_front()
			
			for packet in packet_pack:
				if packet["cmd"] != "PrintJSON":
					continue
				
				var update := print_json_update(packet)
				if update != null:
					updates.append(update)
		
		updates_received.emit(updates)


func _process(delta: float) -> void:
	socket.poll()
	var state := socket.get_ready_state()
	
	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				pending_packets.append(JSON.parse_string(packet_text))
	
	elif state == WebSocketPeer.STATE_CLOSED:
		pass


func print_json_update(packet) -> Update:
	if not packet.has("type"):
		return null
	
	match packet["type"]:
		"Join":
			if packet["data"][0]["text"].contains("playing"):
				var update := Update_Player.new()
				update.update_type = Update_Player.Player_Update_Type.Join
				update.slot = int(packet["slot"])
				return update
		
		"Part":
			if packet["data"][0]["text"].contains("left"):
				var update := Update_Player.new()
				update.update_type = Update_Player.Player_Update_Type.Part
				update.slot = int(packet["slot"])
				return update
		
		"ItemSend":
			var update := Update_Item.new()
			update.item_id = int(packet["item"]["item"])
			update.location_id = int(packet["item"]["location"])
			update.receiving_player_id = int(packet["receiving"])
			update.sending_player_id = int(packet["item"]["player"])
			update.flags = int(packet["item"]["flags"])
			
			return update
	
		"Goal":
			var update := Update_Goal.new()
			update.slot = int(packet["slot"])
			return update
	
		"Collect":
			var update := Update_Collect.new()
			update.slot = int(packet["slot"])
			return update
		
		"Release":
			var update := Update_Release.new()
			update.slot = int(packet["slot"])
			return update
	
	return null


class Game_Inventory:
	var connected_packet: Dictionary
	var received_items_packet: Dictionary


class Update:
	pass


class Update_Player extends Update:
	enum Player_Update_Type { Join, Part }
	var update_type: Player_Update_Type
	var slot: int


class Update_Item extends Update:
	var item_id: int
	var location_id: int
	var receiving_player_id: int
	var sending_player_id: int
	var flags: int


class Update_Goal extends Update:
	var slot: int


class Update_Collect extends Update:
	var slot: int


class Update_Release extends Update:
	var slot: int
