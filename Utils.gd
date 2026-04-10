class_name Utils
extends RefCounted

static func seconds_to_hms(seconds: float) -> String:
	var hours = floor(seconds / 3600)
	var minutes = floor((fposmod(seconds, 3600)) / 60)
	var secs = fposmod(seconds, 60)
	
	return "%02d:%02d:%02d" % [hours, minutes, secs]
