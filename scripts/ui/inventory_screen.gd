extends Control

func _ready():
    _build_inventory_ui()

func _build_inventory_ui():
    var root = VBoxContainer.new()
    root.set_anchors_preset(Control.PRESET_FULL_RECT)
    root.custom_minimum_size = Vector2(1280, 720)
    add_child(root)

    var title = Label.new()
    title.text = "Inventory"
    title.add_theme_font_size_override("font_size", 40)
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    root.add_child(title)

    var hbox = HBoxContainer.new()
    hbox.alignment = BoxContainer.ALIGNMENT_CENTER
    root.add_child(hbox)

    # Fashion
    var fashion_panel = PanelContainer.new()
    fashion_panel.custom_minimum_size = Vector2(300, 200)
    var fashion_text = Label.new()
    fashion_text.text = "Fashion Items\n%d owned" % InventoryManager.fashion_inventory.size()
    fashion_text.add_theme_font_size_override("font_size", 18)
    fashion_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    fashion_panel.add_child(fashion_text)
    hbox.add_child(fashion_panel)

    # Food
    var food_panel = PanelContainer.new()
    food_panel.custom_minimum_size = Vector2(300, 200)
    var food_text = Label.new()
    food_text.text = "Food Items\n%d owned" % InventoryManager.food_inventory.size()
    food_text.add_theme_font_size_override("font_size", 18)
    food_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    food_panel.add_child(food_text)
    hbox.add_child(food_panel)

    # Potions
    var potions_panel = PanelContainer.new()
    potions_panel.custom_minimum_size = Vector2(300, 200)
    var potions_text = Label.new()
    var potion_count = InventoryManager.potions_inventory["health_elixir"] + InventoryManager.potions_inventory["flight_boost_potion"] + InventoryManager.potions_inventory["spell_power_brew"]
    potions_text.text = "Potions\n%d owned" % potion_count
    potions_text.add_theme_font_size_override("font_size", 18)
    potions_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    potions_panel.add_child(potions_text)
    hbox.add_child(potions_panel)

    # Dust
    var dust_panel = PanelContainer.new()
    dust_panel.custom_minimum_size = Vector2(300, 200)
    var dust_text = Label.new()
    dust_text.text = "Magical Dust\n%d" % InventoryManager.magical_dust_count
    dust_text.add_theme_font_size_override("font_size", 18)
    dust_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    dust_panel.add_child(dust_text)
    hbox.add_child(dust_panel)

    var back_btn = Button.new()
    back_btn.text = "Close"
    back_btn.custom_minimum_size = Vector2(200, 60)
    back_btn.pressed.connect(func(): queue_free())
    root.add_child(back_btn)
