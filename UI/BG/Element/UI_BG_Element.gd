class_name UI_BG_Element
extends TextureRect

static func instantiate() -> UI_BG_Element:
	return load("res://UI/BG/Element/UI_BG_Element.tscn").instantiate()


func _ready():
	randomize_icon()


func randomize_icon():
	# Choose a random texture from res://UI_BG/BackgroundElements
	var diraccess := DirAccess.open("res://UI/BG/BackgroundElements")
	if diraccess == null:
		return
	
	var available_textures := diraccess.get_files()
	while true:
		var random_texture := available_textures[randi() % available_textures.size()]
		if random_texture.ends_with(".import"):
			continue
		texture = load("res://UI/BG/BackgroundElements/" + random_texture)
		break
