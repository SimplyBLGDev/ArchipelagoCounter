class_name LayoutTool_StarCounter
extends HBoxContainer

@export var star_0: TextureRect
@export var star_1: TextureRect
@export var star_2: TextureRect

func _ready():
	Counter.update.connect(update)


func update():
	var star_count := Counter.get_item_count("Super Mario 64::Power Star")
	var star_count_str := str(star_count).pad_zeros(3)
	set_number_texture_number(star_0, int(star_count_str[0]))
	set_number_texture_number(star_1, int(star_count_str[1]))
	set_number_texture_number(star_2, int(star_count_str[2]))
	
	star_0.visible = star_count >= 100
	set("theme_override_constants/separation", 0 if star_count < 100 else -20)


func set_number_texture_number(texture: TextureRect, number: int):
	var t: AtlasTexture = texture.texture
	t.region.position.x = 48 * number
