class_name Log
extends PanelContainer

@export var label: RichTextLabel
@export_multiline var message_template := \
	"[color=#{timestamp_color}][{timestamp}][/color] [b][color=#{sender_color}]{sender}[/color][/b] sent " + \
	"[b][color=#{item_color}]{item}[/color][/b] to [b][color=#{receiver_color}]{receiver}[/color][/b] " + \
	"[b][color=#{location_color}]({location})[/color][/b]"
var full_text := ""

func _ready():
	Counter.item_received.connect(print_item)
	
	await Counter.load_complete
	
	for log_entry in Counter.log:
		print_item(log_entry)


func print_item(log_message: LogMessage):
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
			"sender_color": get_color_for_slot(source_player).to_html(),
			"receiver_color": get_color_for_slot(destination_player).to_html(),
			"item_color": Counter.settings.log_item_color.to_html(),
			"location_color": Counter.settings.log_location_color.to_html(),
			"timestamp_color": Counter.settings.log_timestamp_color.to_html(),
			"timestamp": seconds_to_hms(log_message.timestamp)
		})
	
	full_text += "\n" + msg
	queue_redraw()


func get_color_for_slot(slot: String) -> Color:
	if slot in Counter.settings.custom_slot_colors:
		return Counter.settings.custom_slot_colors[slot]
	return Counter.settings.log_default_slot_color


func seconds_to_hms(seconds: float) -> String:
	var hours = floor(seconds / 3600)
	var minutes = floor((fposmod(seconds, 3600)) / 60)
	var secs = fposmod(seconds, 60)
	
	return "%02d:%02d:%02d" % [hours, minutes, secs]


func _draw() -> void:
	label.text = full_text
