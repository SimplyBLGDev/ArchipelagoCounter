## Shows one child at a time, alternates between them over time
class_name LayoutTool_MultiView
extends HBoxContainer

@export var view_change_speed := 4.0 ## Seconds between view changes
@export var fade_time := 0.5 ## Seconds for fade in/out

var timer: Timer
var current_view := 0
var children := []

func _ready():
	children = get_children()
	show_child(current_view)

	timer = Timer.new()
	add_child(timer)
	
	timer.wait_time = view_change_speed
	timer.timeout.connect(_on_view_change_timeout)
	timer.start()


func _on_view_change_timeout():
	# Fade out current view, fade in next view
	var tween := create_tween()
	tween.tween_property(children[current_view], "modulate:a", 0.0, fade_time)
	current_view = (current_view + 1) % len(children)
	children[current_view].modulate.a = 0.0
	tween.tween_callback(show_child.bind(current_view))
	tween.tween_property(children[current_view], "modulate:a", 1.0, fade_time)
	tween.play()


func show_child(ix: int):
	for i in range(len(children)):
		children[i].visible = (i == ix)
