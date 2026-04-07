class_name LogMessage
extends Resource

static func from_json(json) -> LogMessage:
	match json["type"]:
		"item":
			return LogMessage_Item.from_json(json)
		
	
	return null


static func from_update(update: Socket.Update) -> LogMessage:
	if update is Socket.Update_Item:
		var ui := update as Socket.Update_Item
		return LogMessage_Item.new(Time.get_unix_time_from_system(), Counter.save.timer,\
			ui.sending_player_id, ui.receiving_player_id, ui.location_id, ui.item_id, ui.flags)
	
	if update is Socket.Update_Player:
		var up := update as Socket.Update_Player
		var update_type := up.update_type == Socket.Update_Player.Player_Update_Type.Join
		return LogMessage_Join.new(Time.get_unix_time_from_system(), Counter.save.timer,\
			up.slot, update_type)
	
	return null
