@tool
extends Control

@export_tool_button("Process sources", "Callable") var process_sources_button = process_sources

func _ready():
	if Engine.is_editor_hint():
		return
	process_sources()


func process_sources():
	var sources_folder := OS.get_executable_path().get_base_dir() + "/APBGElements/_Sources/"
	
	for file in DirAccess.get_files_at(sources_folder):
		process_source(sources_folder + file)


func process_source(source: String):
	var source_name := source.get_file().get_basename()
	var bg := Image.new()
	bg.load(source)
	var islands := detect_islands(bg)
	
	var i := 0
	# Save all islands to disk
	for island in islands:
		var base_path := OS.get_executable_path().get_base_dir() + "/APBGElements/"
		var path := base_path + source_name + "/" + str(i) + ".png"
		var size := island.get_size()
		if size.x < 4 or size.y < 4:
			continue
		if not DirAccess.dir_exists_absolute(path.get_base_dir()):
			DirAccess.make_dir_absolute(path.get_base_dir())
		island.save_png(path)
		print(path)
		i += 1


func detect_islands(image: Image) -> Array[Image]:
	# Create a texture for each island found in texture and store them in islands array
	var islands: Array[Image] = []
	var width: int = image.get_width()
	var height: int = image.get_height()
	var checked: Array[Vector2i] = []

	for y in range(height):
		for x in range(width):
			if Vector2i(x, y) in checked:
				continue
			var color: Color = image.get_pixel(x, y)
			if color.a > 0:
				var new_island := detect_island(image, Vector2i(x, y))
				for pixel in new_island:
					checked.append(pixel)
				islands.append(create_image_from_island(image, new_island))
	
	return islands


func detect_island(image: Image, position: Vector2i) -> Array[Vector2i]:
	var width: int = image.get_width()
	var height: int = image.get_height()
	# Flood fill from this pixel
	var island: Array[Vector2i] = []
	var queue: Array[Vector2i] = [position]
	var checked: Array[Vector2i] = [position]
	while len(queue) > 0:
		var pixel: Vector2i = queue.pop_front()
		if pixel.x < 0 or pixel.x >= width or pixel.y < 0 or pixel.y >= height:
			continue
		var pixel_color: Color = image.get_pixel(pixel.x, pixel.y)
		if pixel_color.a > 0:
			island.append(pixel)
			for direction in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
				var neighbor: Vector2i = pixel + direction
				if neighbor.x < 0 or neighbor.x >= width or neighbor.y < 0 or neighbor.y >= height:
					continue
				if neighbor in checked:
					continue
				checked.append(neighbor)
				queue.append(neighbor)
	
	return island


func create_image_from_island(image: Image, island: Array[Vector2i]) -> Image:
	var bounds: Rect2i = find_island_bounds(island)
	
	var new_image = Image.create_empty(bounds.size.x, bounds.size.y, false, Image.FORMAT_RGBA8)
	
	for x in range(bounds.size.x):
		for y in range(bounds.size.y):
			var pixel: Vector2i = Vector2i(bounds.position.x + x, bounds.position.y + y)
			var color: Color = image.get_pixel(pixel.x, pixel.y)
			new_image.set_pixel(x, y, color)
	
	return new_image


func find_island_bounds(island: Array[Vector2i]) -> Rect2i:
	var min_x: int = island[0].x
	var max_x: int = island[0].x
	var min_y: int = island[0].y
	var max_y: int = island[0].y
	for pixel in island:
		min_x = min(min_x, pixel.x)
		max_x = max(max_x, pixel.x)
		min_y = min(min_y, pixel.y)
		max_y = max(max_y, pixel.y)
	return Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1)
