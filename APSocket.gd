class_name APSocket
extends Node

var socket = WebSocketPeer.new()
var game: String
var slot: String
var uuid: String

var initialized := false

func _init(url: String, game: String, slot: String, uuid: String):
	self.name = game + "-" + slot
	self.game = game
	self.slot = slot
	self.uuid = uuid

	print ("\n\nConnecting %s" % name)
	var err = socket.connect_to_url(url)
	if err == OK:
		print("Connecting to %s..." % url)
	else:
		push_error("Unable to connect.")
		return


func _process(_delta):
	socket.poll()
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not initialized:
			socket.send_text('[{"cmd":"Connect","password":"","game":"' + game + '","name":"' + slot + '","uuid":"' + uuid + '","version":{"major":0,"minor":6,"build":5,"class":"Version"},"items_handling":7,"tags":["AP","Tracker","TextOnly"],"slot_data":true}]')
			initialized = true

		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				process_packet(JSON.parse_string(packet_text))
			else:
				print("< Got binary data from server: %d bytes" % packet.size())
	elif state == WebSocketPeer.STATE_CLOSING:
		pass
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.


func process_packet(packet_pack):
	for packet in packet_pack:
		match packet["cmd"]:
			"Connected":
				Counter.process_connected(packet)
			"ReceivedItems":
				process_received_items(packet)


func process_received_items(packet):
	for item in packet["items"]:
		if item["player"] <= 0: #Invalid player, not real item
			continue
		
		var item_id := int(item["item"])
		var slot_id := Counter.get_slot_id_from_name(slot)
		
		Counter.get_item(slot_id, item_id)
	
	Counter.update.emit()


func close():
	socket.close()
	queue_free()
