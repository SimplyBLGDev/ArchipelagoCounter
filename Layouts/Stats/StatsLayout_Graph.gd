extends Graph2D

func _ready():
	super._ready()
	await Counter.load_complete
	update()


func update():
	var max_timestamp := 0
	
	for slot in Counter.players:
		var plot_item := add_plot_item(slot["name"], Counter.get_color_for_slot(slot["name"]))
		var acc := 0
		
		for item in get_items_for_slot(int(slot["slot"])):
			var time := item.timestamp
			var percentage_checks := float(acc) / Counter.total_game_checks[slot["name"]]
			percentage_checks *= 100.0
			plot_item.add_point(Vector2(time, percentage_checks))
			max_timestamp = max(max_timestamp, time)
			acc += 1
	
	x_max = max_timestamp


func get_items_for_slot(slot: int) -> Array[LogMessage_Item]:
	var r: Array[LogMessage_Item] = []
	
	for message in Counter.save.log:
		if message is LogMessage_Item and message.sender_id == slot:
			r.append(message)
	
	return r
