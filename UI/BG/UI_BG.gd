class_name UI_BG
extends Control

const BGELEMENTS_FOLDER_NAME := "/APBGElements"

@export var container: Control
@export var movement_angle := Vector2(5.0, 15.0)
@export var movement_speed := 1.0
@export var separation := 128.0
var rng := RandomNumberGenerator.new()
var x_count: int
var y_count: int
var item_textures: Array[Texture2D]
var _item_texture_ix_log: Array

func _ready():
	if not DirAccess.dir_exists_absolute(OS.get_executable_path().get_base_dir() + BGELEMENTS_FOLDER_NAME):
		return
	
	detect_textures()
	create_grid()


func detect_textures():
	item_textures = []
	
	var directory := DirAccess.open(OS.get_executable_path().get_base_dir() + BGELEMENTS_FOLDER_NAME)
	for dir in directory.get_directories():
		if dir == "_Sources":
			continue
		
		var dir_access := DirAccess.open(directory.get_current_dir() + "/" + dir)
		for file in dir_access.get_files():
			var image := Image.new()
			image.load(dir_access.get_current_dir() + "/" + file)
			var texture := ImageTexture.create_from_image(image)
			item_textures.append(texture)


func _process(delta: float) -> void:
	for child in container.get_children():
		child.position += movement_angle * delta * movement_speed
		if child.position.y > (y_count - 1) * separation:
			child.position.y -= y_count * separation
			randomize_icon(child)
		
		if child.position.x > (x_count - 1) * separation:
			child.position.x -= x_count * separation
			randomize_icon(child)


func create_grid():
	# Create a UI_BG_Element per 256 pixels in the screen
	x_count = ceili(2500.0 / separation) + 2
	y_count = ceili(1500.0 / separation) + 2
	for x in range(x_count):
		for y in range(y_count):
			var element := UI_BG_Element.instantiate()
			element.position = Vector2(x * separation, y * separation)
			randomize_icon(element)
			container.add_child(element)


func randomize_icon(child: TextureRect):
	if len(_item_texture_ix_log) == 0:
		_item_texture_ix_log = range(len(item_textures))
	
	var ix := rng.randi() % len(_item_texture_ix_log)
	child.texture = item_textures[_item_texture_ix_log[ix]]
	_item_texture_ix_log.remove_at(ix)
