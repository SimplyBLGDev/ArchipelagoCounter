extends Log

func print_item(log_message: LogMessage):
	var source_player := Counter.get_player_name_from_id(log_message.sender_id)
	var destination_player := Counter.get_player_name_from_id(log_message.receiver_id)
	var item_name := Counter.get_item_name_from_id(log_message.receiver_id, log_message.item_id)
	var location_name := Counter.get_location_name_from_id(log_message.sender_id, log_message.location_id)
	
	var msg := "[color=#{timestamp_color}][{timestamp}][/color] [b][color=#{sender_color}]{sender}[/color][/b] sent [b][color=#{item_color}]{item}[/color][/b] to [b][color=#{receiver_color}]{receiver}[/color][/b] [b][color=#{location_color}]({location})[/color][/b]".format(
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
			"timestamp": seconds_to_hmsd(log_message.timestamp)
		})
	
	full_text += "\n" + msg
	queue_redraw()


func seconds_to_hmsd(seconds: float) -> String:
	var hours = floor(seconds / 3600)
	var minutes = floor((fposmod(seconds, 3600)) / 60)
	var secs = fposmod(seconds, 60)
	
	return "%02d:%02d:%02d" % [hours, minutes, secs]
