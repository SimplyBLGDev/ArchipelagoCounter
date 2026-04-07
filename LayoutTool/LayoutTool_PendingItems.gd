class_name LayoutTool_PendingItems
extends PanelContainer

@export var label: RichTextLabel

# relates slots to a dictionary relating logical advancement items to their counts, for items that have not yet been used
var pending_items: Dictionary[String, Dictionary] = {}
var full_text := ""

func _ready() -> void:
	Counter.log.connect(log_received)
	
	await Counter.load_complete
	
	for log_entry in Counter.save.log:
		log_received(log_entry)


func log_received(log_message: LogMessage):
	if log_message is LogMessage_Item:
		var item: LogMessage_Item = log_message
		if item.flags & 1 == 0: # Not a Logical advancement item
			return
		
		var receiver := Counter.get_player_name_from_id(item.receiver_id)
		var item_name := Counter.get_item_name_from_id(item.receiver_id, item.item_id)
		
		if receiver not in pending_items:
			pending_items[receiver] = {}
		if item_name not in pending_items[receiver]:
			pending_items[receiver][item_name] = 0

		pending_items[receiver][item_name] += 1

	elif log_message is LogMessage_Join:
		var join: LogMessage_Join = log_message
		var player_name := Counter.get_player_name_from_id(join.slot)
		if player_name in pending_items:
			pending_items.erase(player_name)
	
	full_text = calculate_text()
	
	queue_redraw()


func calculate_text():
	var t = ""
	for player in pending_items.keys():
		var items := pending_items[player]
		for item in items.keys():
			var count: int = items[item]
			if t != "":
				t += "\n"
			t += "[b][color=#{player_color}]{player}[/color][/b]>[b][color=#{item_color}]{item}[/color][/b]x{count}".format(
				{
					"player": player,
					"item": item,
					"count": str(count),
					"player_color": Counter.get_color_for_slot(player).to_html(),
					"item_color": Counter.settings.log_item_color.to_html()
				})
	
	return t


func _draw() -> void:
	label.text = full_text
