class_name InventoryGridLite
extends GridContainer
## Basic drag-and-drop grid view for Modular Grid Inventory Lite.

var _bag: InventoryBagLite = null


class LiteCell extends PanelContainer:
	var idx: int = 0
	var bag: InventoryBagLite = null
	var icon_rect: TextureRect
	var count_lbl: Label

	func _init(p_idx: int, p_bag: InventoryBagLite) -> void:
		idx = p_idx
		bag = p_bag
		custom_minimum_size = Vector2(60, 60)
		var box := StyleBoxFlat.new()
		box.bg_color = Color(0.08, 0.10, 0.14)
		box.border_color = Color(0.28, 0.32, 0.42)
		box.set_border_width_all(1)
		box.set_corner_radius_all(6)
		add_theme_stylebox_override("panel", box)
		var c := Control.new()
		c.mouse_filter = Control.MOUSE_FILTER_IGNORE
		c.set_anchors_preset(Control.PRESET_FULL_RECT)
		add_child(c)
		icon_rect = TextureRect.new()
		icon_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		icon_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		icon_rect.offset_left = 4
		icon_rect.offset_top = 4
		icon_rect.offset_right = -4
		icon_rect.offset_bottom = -4
		icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		c.add_child(icon_rect)
		count_lbl = Label.new()
		count_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		count_lbl.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		count_lbl.offset_left = -30
		count_lbl.offset_top = -18
		count_lbl.offset_right = -3
		count_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		c.add_child(count_lbl)

	func refresh() -> void:
		var entry := bag.get_slot(idx)
		if entry.is_empty():
			icon_rect.texture = null
			count_lbl.text = ""
			return
		var loop := Engine.get_main_loop() as SceneTree
		var db := loop.root.get_node_or_null("ItemDBLite")
		if db != null:
			icon_rect.texture = db.get_icon_texture(str(entry.get("item_id", "")))
		var amt := int(entry.get("amount", 1))
		count_lbl.text = str(amt) if amt > 1 else ""

	func _get_drag_data(_at_position: Vector2) -> Variant:
		var entry := bag.get_slot(idx)
		if entry.is_empty():
			return null
		return {"lite_slot": idx}

	func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
		return typeof(data) == TYPE_DICTIONARY and (data as Dictionary).has("lite_slot")

	func _drop_data(_at_position: Vector2, data: Variant) -> void:
		var from_i := int((data as Dictionary).get("lite_slot", -1))
		bag.swap_or_merge(from_i, idx)


func bind_bag(bag: InventoryBagLite, cols: int = 6) -> void:
	columns = cols
	add_theme_constant_override("h_separation", 6)
	add_theme_constant_override("v_separation", 6)
	_bag = bag
	for ch in get_children():
		ch.queue_free()
	for i in range(_bag.capacity):
		var cell := LiteCell.new(i, _bag)
		add_child(cell)
	_bag.bag_changed.connect(refresh_cells)
	refresh_cells()


func refresh_cells() -> void:
	for ch in get_children():
		if ch.has_method("refresh"):
			ch.refresh()
