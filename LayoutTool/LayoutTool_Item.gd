class_name LayoutTool_Item
extends TextureRect

enum MISSING_TEXTURE_MODE {
	SEMI_TRANSPARENT_BW,
	SEMI_TRANSPARENT_BW_INVERTED,
}

@export var item_code := ""
@export var threshold := 1
@export var missing_texture_mode := MISSING_TEXTURE_MODE.SEMI_TRANSPARENT_BW

var original_texture: Texture2D
var missing_texture: Texture2D

func _ready():
	original_texture = texture
	missing_texture = create_missing_texture(original_texture)
	Counter.update.connect(update)


func update():
	var item_count := Counter.get_item_count(item_code)
	texture = original_texture if item_count >= threshold else missing_texture


func create_missing_texture(texture: Texture2D) -> Texture2D:
	var original_image = texture.get_image()
	
	match missing_texture_mode:
		MISSING_TEXTURE_MODE.SEMI_TRANSPARENT_BW:
			return generate_semi_transparent_bw_texture(original_image)
		MISSING_TEXTURE_MODE.SEMI_TRANSPARENT_BW_INVERTED:
			return generate_semi_transparent_bw_inverted_texture(original_image)
	
	return ImageTexture.create_from_image(original_image)


func generate_semi_transparent_bw_texture(image: Image) -> Texture2D:
	var new_image = Image.new()
	new_image = new_image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var gray = (color.r + color.g + color.b) / 3.0
			var alpha = color.a * 0.5
			new_image.set_pixel(x, y, Color(gray, gray, gray, alpha))
	
	return ImageTexture.create_from_image(new_image)


func generate_semi_transparent_bw_inverted_texture(image: Image) -> Texture2D:
	var new_image = Image.new()
	new_image.create(image.get_width(), image.get_height(), false, Image.FORMAT_RGBA8)
	
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			var gray = (color.r + color.g + color.b) / 3.0
			var inverted_gray = 1.0 - gray
			var alpha = color.a * 0.5
			new_image.set_pixel(x, y, Color(inverted_gray, inverted_gray, inverted_gray, alpha))
	
	return ImageTexture.create_from_image(new_image)
