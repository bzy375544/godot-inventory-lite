@tool
extends EditorPlugin

const AUTOLOAD_NAME := "ItemDBLite"
const AUTOLOAD_PATH := "res://addons/modular_inventory_lite/item_db_lite.gd"


func _enter_tree() -> void:
	if not ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		add_autoload_singleton(AUTOLOAD_NAME, AUTOLOAD_PATH)


func _disable_plugin() -> void:
	if ProjectSettings.has_setting("autoload/" + AUTOLOAD_NAME):
		remove_autoload_singleton(AUTOLOAD_NAME)
