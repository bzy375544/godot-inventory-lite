class_name InventoryBagLite
extends RefCounted
## Starter 12-slot grid container supporting basic stack addition, removal, and slot swapping.
## Upgrade to Full Edition for weight caps, atomic multi-item preflight, stack splitting,
## cross-container loot chests, 8-slot equipment stat aggregation, recipe crafting & hotbars.

signal bag_changed()

var capacity: int = 12
var _slots: Array = []


func _init(p_capacity: int = 12) -> void:
	capacity = maxi(1, p_capacity)
	_slots.resize(capacity)
	for i in range(capacity):
		_slots[i] = {}


func _max_stack_for(item_id: String) -> int:
	var loop := Engine.get_main_loop()
	if loop is SceneTree:
		var db := (loop as SceneTree).root.get_node_or_null("ItemDBLite")
		if db != null and db.has_method("get_item"):
			var d: Dictionary = db.get_item(item_id)
			return maxi(1, int(d.get("max_stack", 1)))
	return 1


func get_slot(idx: int) -> Dictionary:
	if idx < 0 or idx >= capacity:
		return {}
	return (_slots[idx] as Dictionary).duplicate(true)


func add_item(item_id: String, amount: int = 1) -> int:
	if amount <= 0 or item_id.is_empty():
		return 0
	var max_s := _max_stack_for(item_id)
	var rem := amount
	if max_s > 1:
		for i in range(capacity):
			var s: Dictionary = _slots[i]
			if not s.is_empty() and str(s.get("item_id", "")) == item_id:
				var cur := int(s.get("amount", 0))
				var take := mini(rem, max_s - cur)
				if take > 0:
					s["amount"] = cur + take
					rem -= take
					if rem == 0:
						bag_changed.emit()
						return amount
	for i in range(capacity):
		if (_slots[i] as Dictionary).is_empty():
			var take := mini(rem, max_s)
			_slots[i] = {"item_id": item_id, "amount": take}
			rem -= take
			if rem == 0:
				break
	bag_changed.emit()
	return amount - rem


func swap_or_merge(from_idx: int, to_idx: int) -> void:
	if from_idx < 0 or from_idx >= capacity or to_idx < 0 or to_idx >= capacity or from_idx == to_idx:
		return
	var src: Dictionary = _slots[from_idx]
	var dst: Dictionary = _slots[to_idx]
	if src.is_empty():
		return
	if not dst.is_empty() and str(src.get("item_id", "")) == str(dst.get("item_id", "")):
		var max_s := _max_stack_for(str(src["item_id"]))
		var room := max_s - int(dst.get("amount", 0))
		if room > 0:
			var move_n := mini(int(src.get("amount", 0)), room)
			dst["amount"] = int(dst["amount"]) + move_n
			var left := int(src["amount"]) - move_n
			_slots[from_idx] = {} if left <= 0 else {"item_id": src["item_id"], "amount": left}
			bag_changed.emit()
			return
	_slots[from_idx] = dst
	_slots[to_idx] = src
	bag_changed.emit()


func clear() -> void:
	for i in range(capacity):
		_slots[i] = {}
	bag_changed.emit()
