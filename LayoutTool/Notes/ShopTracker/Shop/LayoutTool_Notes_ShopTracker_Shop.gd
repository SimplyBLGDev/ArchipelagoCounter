class_name LayoutTool_Notes_ShopTracker_Shop
extends PanelContainer

@export var title: Button
@export var container: Container
@export var add_item: Button

var items: Array[LayoutTool_Notes_ShopTracker_Item]

static func instantiate(title: String, color: Color, shops: Array) -> LayoutTool_Notes_ShopTracker_Shop:
	var instance: LayoutTool_Notes_ShopTracker_Shop = load("res://LayoutTool/Notes/ShopTracker/Shop/LayoutTool_Notes_ShopTracker_Shop.tscn").instantiate()
	instance.title.text = title
	instance.get("theme_override_styles/panel").bg_color = color
	instance.spawn_entries(shops)
	return instance


func spawn_entries(entries: Array):
	for entry in entries:
		spawn_entry(entry)


func spawn_entry(data: Dictionary):
	var item_instance := LayoutTool_Notes_ShopTracker_Item.from_data(data)
	item_instance.delete.connect(delete_entry.bind(item_instance))
	container.add_child(item_instance)
	items.append(item_instance)


func delete_entry(entry: LayoutTool_Notes_ShopTracker_Item):
	entry.queue_free()
	items.erase(entry)


func get_data() -> Array:
	var item_data := []
	for item in items:
		item_data.append(item.get_data())
	
	return item_data


func _on_shop_title_pressed() -> void:
	add_item.visible = not add_item.visible
	for item in items:
		item.visible = add_item.visible


func _on_add_entry_pressed() -> void:
	spawn_entry({
		"checked": false,
		"item": "",
		"price": ""
	})
