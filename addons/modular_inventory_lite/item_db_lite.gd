extends Node
## Lightweight JSON item registry for Modular Grid Inventory Lite.

var _items: Dictionary = {}

const RARITY_COLORS := {
	"common": Color(0.68, 0.72, 0.78),
	"uncommon": Color(0.30, 0.84, 0.48),
	"rare": Color(0.28, 0.64, 0.98),
	"epic": Color(0.74, 0.40, 0.98),
	"legendary": Color(0.98, 0.70, 0.18),
}


func load_items_from_json(res_path: String) -> int:
	if not FileAccess.file_exists(res_path):
		return 0
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(res_path))
	if typeof(parsed) != TYPE_ARRAY:
		return 0
	_items.clear()
	for entry: Variant in parsed:
		if typeof(entry) == TYPE_DICTIONARY:
			var d: Dictionary = entry
			var iid := str(d.get("id", "")).strip_edges()
			if not iid.is_empty():
				_items[iid] = d.duplicate(true)
	return _items.size()


func get_item(item_id: String) -> Dictionary:
	return _items.get(item_id, {})


func get_rarity_color(rarity: String) -> Color:
	return RARITY_COLORS.get(rarity.to_lower(), RARITY_COLORS["common"])


func get_icon_texture(item_id: String) -> Texture2D:
	var d := get_item(item_id)
	var p := str(d.get("icon_path", ""))
	if p.begins_with("res://") and ResourceLoader.exists(p):
		var tex := ResourceLoader.load(p)
		if tex is Texture2D:
			return tex
	return null
