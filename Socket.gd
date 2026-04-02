class_name Socket
extends Node

signal packet_received(data: String)
signal room_info_received

var socket = WebSocketPeer.new()
var url := ""
var room_info := {}


func _init(url: String) -> void:
	self.url = url


func _ready():
	var err = socket.connect_to_url(url)
	if err == OK:
		print("Connecting to %s..." % url)
	else:
		push_error("Unable to connect.")
		return


func _process(delta: float) -> void:
	socket.poll()
	var state = socket.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			var packet = socket.get_packet()
			if socket.was_string_packet():
				var packet_text = packet.get_string_from_utf8()
				process_packet(JSON.parse_string(packet_text))
	
	elif state == WebSocketPeer.STATE_CLOSED:
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.


func close():
	socket.close()
	queue_free()


func process_packet(packet):
	match packet["cmd"]:
		"RoomInfo":
			process_room_info(packet)
		"ReceivedItems":
			process_received_items(packet)
		"PrintJSON":
			process_print_json(packet)
		"Connected":
			process_connected(packet)
		"DataPackage":
			process_data_package(packet)


func process_room_info(packet):
	room_info = packet
	room_info_received.emit()
