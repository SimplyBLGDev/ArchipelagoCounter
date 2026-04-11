class_name LayoutTool_Notes_ShopTracker
extends VBoxContainer

@export var shops: Array[LayoutTool_Notes_ShopTracker_Shop_Shop]
var shop_instances: Dictionary[String, LayoutTool_Notes_ShopTracker_Shop]

func generate_from_data(data: Dictionary):
	for shop in shops:
		var shop_data = data[shop.name] if shop.name in data else []
		var shop_instance := LayoutTool_Notes_ShopTracker_Shop.instantiate(shop.name, shop.color, shop_data)
		shop_instance.name = shop.name
		add_child(shop_instance)
		shop_instances[shop.name] = shop_instance


func get_data() -> Dictionary:
	var r := {}
	for shop in shops:
		r[shop.name] = shop_instances[shop.name].get_data()
	return r
