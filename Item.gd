class_name Item
extends TextureRect

@export var item_code := ""

func _ready():
	Counter.update.connect(update)


func update():
	texture.region.position.x = 16 if item_code in Counter.items else 0
