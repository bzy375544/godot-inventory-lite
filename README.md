# Modular Inventory Lite — Grid Inventory & Drag-and-Drop (Godot 4)

A free, zero-dependency starter addon for Godot 4 that gives you a **JSON item registry**, **stack merging**, and a **drag-and-drop grid container** in about three minutes.

100% GDScript, written for Godot 4.3. No external dependencies, no scene wiring — build the bag in code, bind it to a grid, done.

## Install

1. Grab the addon folder `addons/modular_inventory_lite/` (download this repo as a ZIP, or `git clone` it) and copy it into your project's `res://addons/` folder.
   > Also submitted to the **Godot Asset Library** as `Modular Inventory Lite` — it is currently in review. Once accepted you will also be able to install it straight from the editor's **AssetLib** tab.
2. **Project → Project Settings → Plugins** and enable **Modular Grid Inventory Lite**. This registers the `ItemDBLite` autoload.

## Usage

```gdscript
# 1. Load an item table (JSON array of {id, name, max_stack, rarity, ...})
ItemDBLite.load_items_from_json("res://items.json")

# 2. Create a bag and put things in it
var bag := InventoryBagLite.new(12)
bag.add_item("crimson_potion", 4)

# 3. Draw it
var grid := InventoryGridLite.new()
add_child(grid)
grid.bind_bag(bag, 6)          # 6 columns
```

| API | What it does |
| :--- | :--- |
| `ItemDBLite.load_items_from_json(res_path) -> int` | Loads an item table, returns how many entries were parsed |
| `ItemDBLite.get_item(item_id)` | Item definition dictionary |
| `ItemDBLite.get_rarity_color(rarity)` | Colour-coded rarity helper |
| `InventoryBagLite.new(capacity)` | Slot container; emits `bag_changed` |
| `bag.add_item(item_id, amount)` | Stacks into existing slots first |
| `bag.swap_or_merge(from_idx, to_idx)` | What drag-and-drop calls for you |
| `InventoryGridLite.bind_bag(bag, cols)` | Renders the bag as a grid with drag-and-drop |

## Lite vs. Full kit

| Capability | Lite (free) | Full kit ($7.99) |
| :--- | :---: | :---: |
| JSON item registry + single-grid drag swap | Yes | Yes (+ CSV and `.tres` `ItemDef` resources) |
| Stack merging | Yes | Yes |
| Atomic multi-item preflight (`can_add_items`) — zero item loss / duplication | — | Yes |
| Weight cap system with live colour-coded meter | — | Yes |
| Stack splitting slider, shift-click actions | — | Yes |
| Cross-container transfers (chest → bag → equipment) | — | Yes |
| 8-slot equipment panel with stat diff previews | — | Yes |
| Transactional crafting / forge with atomic consume | — | Yes |

Full kit (HTML5 demo you can play in the browser): **https://bzy375544.itch.io/godot4-grid-inventory-crafting**

This Lite addon on itch.io (one-click download, no signup): **https://bzy375544.itch.io/godot4-grid-inventory-crafting-lite**

## License

MIT — free for commercial use, no attribution required. See [LICENSE](LICENSE).
