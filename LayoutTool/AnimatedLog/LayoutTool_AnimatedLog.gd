class_name LayoutTool_AnimatedLog
extends PanelContainer

@export var entry_container: Container
@export var space_keeper: Control
@export var scroll_container: ScrollContainer

@export var print_excluded_locations := false
@export_multiline var message_template := \
	"[color=#{timestamp_color}][{timestamp}][/color] [b][color=#{sender_color}]{sender}[/color][/b] sent " + \
	"[b][color=#{item_color}]{item}[/color][/b] to [b][color=#{receiver_color}]{receiver}[/color][/b] " + \
	"[b][color=#{location_color}]({location})[/color][/b]"

var text_queue: Array[String] = []
var _tween: Tween

func _ready():
	resized.connect(_on_resize)
	_on_resize()
	await Counter.loaded()
	Counter.log.connect(_on_log)
	
	spawn_visible_logs()
	pass


func _process(delta: float) -> void:
	if len(text_queue) == 0:
		return
	
	if _tween != null:
		return
	
	var entry := LayoutTool_AnimatedLog_Entry.instantiate(text_queue.pop_front())
	animate_entry(entry)


func spawn_visible_logs():
	var acc_size := 0
	var i := 1
	
	if len(Counter.save.log) == 0:
		return
	
	while acc_size <= size.y:
		if i > len(Counter.save.log):
			break
		
		var log := Counter.save.log[-i]
		# Add the log entry to the queue
		_on_log(log)
		i += 1
		if len(text_queue) == 0:
			continue
		
		# Create the entry node
		var entry := LayoutTool_AnimatedLog_Entry.instantiate(text_queue.pop_front())
		# Add the entry node at the top of the container
		entry_container.add_child(entry)
		entry_container.move_child(entry, 1) # Position 0 reserved for space_keeper
		acc_size += entry.size.y
	
	await get_tree().process_frame
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value - size.y + acc_size


func _on_log(log_message: LogMessage):
	if log_message is LogMessage_Item:
		print_item(log_message)


func print_item(log_message: LogMessage_Item):
	if not print_excluded_locations and Counter.is_location_excluded(log_message.sender_id, log_message.location_id):
		return
	
	var source_player := Counter.get_player_name_from_id(log_message.sender_id)
	var destination_player := Counter.get_player_name_from_id(log_message.receiver_id)
	var item_name := Counter.get_item_name_from_id(log_message.receiver_id, log_message.item_id)
	var location_name := Counter.get_location_name_from_id(log_message.sender_id, log_message.location_id)
	
	var msg := message_template.format(
		{
			"sender": source_player,
			"receiver": destination_player,
			"item": item_name,
			"location": location_name,
			"sender_color": Counter.get_color_for_slot(source_player).to_html(),
			"receiver_color": Counter.get_color_for_slot(destination_player).to_html(),
			"item_color": Counter.settings.log_item_color.to_html(),
			"location_color": Counter.settings.log_location_color.to_html(),
			"timestamp_color": Counter.settings.log_timestamp_color.to_html(),
			"timestamp": Utils.seconds_to_hms(log_message.timestamp)
		})
	
	text_queue.append(msg)


func animate_entry(entry: LayoutTool_AnimatedLog_Entry) -> void:
	entry_container.add_child(entry)
	entry.modulate.a = 0.0
	
	var anim := entry.create_tween()
	_tween = anim
	anim.set_parallel()
	# Fade entry in
	anim.tween_property(entry, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	# Scroll to bottom
	var target_scroll := scroll_container.get_v_scroll_bar().max_value - size.y + entry.size.y
	anim.tween_property(scroll_container, "scroll_vertical", target_scroll, 1.0).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	
	anim.play()
	await anim.finished
	_tween = null
	delete_oob_entries()


func _on_resize():
	space_keeper.custom_minimum_size.y = size.y


func delete_oob_entries():
	for child in entry_container.get_children():
		var bottom_left: float = child.position.y + child.size.y
		if bottom_left < entry_container.size.y - size.y:
			child.queue_free()
