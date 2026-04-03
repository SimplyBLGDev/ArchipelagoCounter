class_name LayoutTool_ItemAtlas
extends TextureRect

@export var frames_in_atlas := 1
@export var item_code: String

func _ready():
	Counter.update.connect(update)


func update():
	var atlas_width: int = texture.atlas.get_width()
	var frame_width := atlas_width / frames_in_atlas
	var item_count := Counter.get_item_count(item_code)
	
	texture.region.position.x = frame_width * item_count
	texture.region.size.x = frame_width
