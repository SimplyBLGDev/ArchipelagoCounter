class_name LogMessage
extends Resource

static func from_json(json) -> LogMessage:
	match json["type"]:
		"item":
			return LogMessage_Item.from_json(json)
		"join", "part", "goal", "collect", "release", "deathlink":
			return LogMessage_SlotEvent.from_json(json)
	
	return null


static func from_update(update: Socket.Update) -> LogMessage:
	if update is Socket.Update_Item:
		var ui := update as Socket.Update_Item
		return LogMessage_Item.new(Time.get_unix_time_from_system(), Counter.save.timer,\
			ui.sending_player_id, ui.receiving_player_id, ui.location_id, ui.item_id, ui.flags)
	
	elif update is Socket.Update_Player:
		var up := update as Socket.Update_Player
		var update_type := LogMessage_SlotEvent.TYPE.JOIN if up.update_type == Socket.Update_Player.Player_Update_Type.Join else LogMessage_SlotEvent.TYPE.PART
		return LogMessage_SlotEvent.new(update_type, Time.get_unix_time_from_system(),\
			Counter.save.timer, up.slot)
	
	elif update is Socket.Update_Goal:
		var up := update as Socket.Update_Goal
		return LogMessage_SlotEvent.new(LogMessage_SlotEvent.TYPE.GOAL, Time.get_unix_time_from_system(),\
			Counter.save.timer, up.slot)
	
	elif update is Socket.Update_Release:
		var up := update as Socket.Update_Release
		return LogMessage_SlotEvent.new(LogMessage_SlotEvent.TYPE.RELEASE, Time.get_unix_time_from_system(),\
			Counter.save.timer, up.slot)
	
	elif update is Socket.Update_Collect:
		var up := update as Socket.Update_Collect
		return LogMessage_SlotEvent.new(LogMessage_SlotEvent.TYPE.COLLECT, Time.get_unix_time_from_system(),\
			Counter.save.timer, up.slot)
	
	elif update is Socket.Update_DeathLink:
		var up := update as Socket.Update_DeathLink
		return LogMessage_SlotEvent.new(LogMessage_SlotEvent.TYPE.DEATHLINK, Time.get_unix_time_from_system(),\
			Counter.save.timer, up.slot)
	
	return null
