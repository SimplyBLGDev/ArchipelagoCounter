class_name LayoutTool_PendingItems
extends PanelContainer

@export var grid: GridContainer
@export var panel_style_even: StyleBox
@export var panel_style_odd: StyleBox

# relates slots to a dictionary relating logical advancement items to their counts, for items that have not yet been used
var pending_items: Dictionary[String, Dictionary] = {}

func _ready() -> void:
	Counter.log.connect(log_received)
	Counter.update.connect(generate_grid)
	
	await Counter.loaded()
	
	for log_entry in Counter.save.log:
		update_pending_items_list(log_entry)
	
	generate_grid()


func log_received(log_message: LogMessage):
	update_pending_items_list(log_message)


func update_pending_items_list(log_message: LogMessage):
	if log_message is LogMessage_Item:
		var item: LogMessage_Item = log_message
		if item.flags & 1 == 0: # Not a Logical advancement item
			return
		
		var receiver := Counter.get_player_name_from_id(item.receiver_id)
		var item_name := Counter.get_item_name_from_id(item.receiver_id, item.item_id)
		
		## Don't count items received by an active player
		if receiver in Counter.active_players:
			return
		
		if receiver not in pending_items:
			pending_items[receiver] = {}
		if item_name not in pending_items[receiver]:
			pending_items[receiver][item_name] = 0
		
		pending_items[receiver][item_name] += 1
	
	elif log_message is LogMessage_SlotEvent:
		var event: LogMessage_SlotEvent = log_message
		if event.type not in ["join", "part"]:
			return
		
		var player_name := Counter.get_player_name_from_id(event.slot)
		if player_name in pending_items:
			pending_items.erase(player_name)


func generate_grid():
	for child in grid.get_children():
		child.queue_free()
	
	var count := 0
	
	for player in pending_items.keys():
		for item in pending_items[player].keys():
			var player_entry := LayoutTool_PendingItems_Entry.instantiate(player, Counter.get_color_for_slot(player), true)
			var item_entry := LayoutTool_PendingItems_Entry.instantiate(item, Counter.settings.log_item_color, true, HorizontalAlignment.HORIZONTAL_ALIGNMENT_LEFT)
			var count_text := "x" + str(pending_items[player][item]) if pending_items[player][item] > 1 else ""
			var count_entry := LayoutTool_PendingItems_Entry.instantiate(count_text, Color.WHITE, false)
			
			var panel_style := panel_style_even if count % 2 == 0 else panel_style_odd
			item_entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			player_entry.add_theme_stylebox_override(&"panel", panel_style)
			item_entry.add_theme_stylebox_override(&"panel", panel_style)
			count_entry.add_theme_stylebox_override(&"panel", panel_style)
			
			grid.add_child(player_entry)
			grid.add_child(item_entry)
			grid.add_child(count_entry)
			
			count += 1
