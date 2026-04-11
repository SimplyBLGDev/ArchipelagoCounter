class_name LayoutTool_Notes_ShopTracker_Item
extends PanelContainer

signal delete

@export var check_box: CheckBox
@export var item_name: LineEdit
@export var price: LineEdit

static func instantiate() -> LayoutTool_Notes_ShopTracker_Item:
	return load("res://LayoutTool/Notes/ShopTracker/Item/LayoutTool_Notes_ShopTracker_Item.tscn").instantiate()


static func from_data(data: Dictionary) -> LayoutTool_Notes_ShopTracker_Item:
	var instance := instantiate()
	instance.check_box.button_pressed = data["checked"]
	instance.item_name.text = data["item"]
	instance.price.text = data["price"]
	return instance


func get_data() -> Dictionary:
	return {
		"checked": check_box.button_pressed,
		"item": item_name.text,
		"price": price.text
	}


func _on_delete_pressed() -> void:
	delete.emit()
