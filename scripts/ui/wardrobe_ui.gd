extends Control

var wardrobe_items = {
    "crop_top_pink": {"name": "Pink Crop Top", "cost": 50, "owned": false},
    "crop_top_blue": {"name": "Blue Crop Top", "cost": 50, "owned": false},
    "mesh_gloves_white": {"name": "White Mesh Gloves", "cost": 30, "owned": true},
    "mesh_gloves_purple": {"name": "Purple Mesh Gloves", "cost": 30, "owned": false},
    "boots_platform": {"name": "Platform Boots", "cost": 75, "owned": false},
    "wings_fairy": {"name": "Fairy Wings", "cost": 100, "owned": false},
    "halo_magic": {"name": "Magic Halo", "cost": 120, "owned": false},
    "dress_formal": {"name": "Formal Dress", "cost": 150, "owned": false}
}

func _ready():
    _build_wardrobe_ui()

func _build_wardrobe_ui():
    var root = VBoxContainer.new()
    root.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.custom_minimum_size = Vector2(1280, 720)
    add_child(root)

    var title = Label.new()
    title.text = "Wardrobe Selection"
    title.add_theme_font_size_override("font_size", 36)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    root.add_child(title)

    var dust_label = Label.new()
    dust_label.text = "Available Dust: %d" % InventoryManager.magical_dust_count
    dust_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dust_label.add_theme_font_size_override("font_size", 20)
    root.add_child(dust_label)

    var grid = GridContainer.new()
    grid.columns = 4
    grid.custom_minimum_size = Vector2(1200, 500)
    root.add_child(grid)

    for item_id in wardrobe_items.keys():
        var item = wardrobe_items[item_id]
        var btn = Button.new()
        btn.custom_minimum_size = Vector2(250, 100)
        btn.text = "%s\n%s Dust" % [item["name"], item["cost"]]
        btn.modulate = Color.GREEN if item["owned"] else Color.WHITE
        btn.pressed.connect(_on_item_selected.bind(item_id))
        grid.add_child(btn)

    var back_btn = Button.new()
    back_btn.text = "Back to Dorm"
    back_btn.custom_minimum_size = Vector2(200, 50)
    back_btn.pressed.connect(_on_back_pressed)
    root.add_child(back_btn)

func _on_item_selected(item_id: String):
    var item = wardrobe_items[item_id]
    if item["owned"]:
        print("Equipped: %s" % item["name"])
        GlobalCharacterManager.current_player.equip_gear(item_id)
    else:
        if InventoryManager.magical_dust_count >= item["cost"]:
            InventoryManager.magical_dust_count -= item["cost"]
            item["owned"] = true
            InventoryManager.add_fashion_item(item_id)
            print("Purchased: %s" % item["name"])
            queue_redraw()
        else:
            print("Not enough dust!")

func _on_back_pressed():
    queue_free()
