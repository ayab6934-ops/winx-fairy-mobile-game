extends Control

@export var water_data: FairyCharacterData
@export var fire_data: FairyCharacterData
@export var nature_data: FairyCharacterData
@export var air_data: FairyCharacterData

var element_buttons: Dictionary = {}
var gender_buttons: Dictionary = {}
var selected_summary: Label

func _ready():
    _ensure_resources()
    _build_ui()
    _on_element_selected("Water")
    _on_gender_selected("female")

func _ensure_resources():
    if water_data == null:
        water_data = FairyCharacterData.new()
        water_data.fairy_name = "Bloom"
        water_data.fairy_element = "Water"
        water_data.signature_color = Color("#90D6FF")
        water_data.base_flight_speed = 12.0
        water_data.base_vertical_speed = 8.0
        water_data.base_spell_damage = 18.0
        water_data.lore_description = "A hopeful guardian of the crystal lagoons and Alfea's moonlit bloom halls."

    if fire_data == null:
        fire_data = FairyCharacterData.new()
        fire_data.fairy_name = "Stella"
        fire_data.fairy_element = "Fire"
        fire_data.signature_color = Color("#FF9E59")
        fire_data.base_flight_speed = 10.5
        fire_data.base_vertical_speed = 7.5
        fire_data.base_spell_damage = 22.0
        fire_data.lore_description = "A radiant warrior who turns every battle into a blazing statement."

    if nature_data == null:
        nature_data = FairyCharacterData.new()
        nature_data.fairy_name = "Flora"
        nature_data.fairy_element = "Nature"
        nature_data.signature_color = Color("#7BC4B5")
        nature_data.base_flight_speed = 11.0
        nature_data.base_vertical_speed = 8.0
        nature_data.base_spell_damage = 17.0
        nature_data.lore_description = "A patient protector who grows radiant support magic from the forest floor."

    if air_data == null:
        air_data = FairyCharacterData.new()
        air_data.fairy_name = "Musa"
        air_data.fairy_element = "Air"
        air_data.signature_color = Color("#B8E1FF")
        air_data.base_flight_speed = 13.5
        air_data.base_vertical_speed = 9.5
        air_data.base_spell_damage = 20.0
        air_data.lore_description = "A swift, elegant tactician whose songs turn the air into a weapon."

func _build_ui():
    var root = VBoxContainer.new()
    root.name = "SelectionRoot"
    root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    root.size_flags_vertical = Control.SIZE_EXPAND_FILL
    root.set_anchors_preset(Control.PRESET_FULL_RECT)
    add_child(root)

    var title = Label.new()
    title.text = "Winx Fairy Academy"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 42)
    root.add_child(title)

    var subtitle = Label.new()
    subtitle.text = "Choose your element and begin your rise through Alfea."
    subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    root.add_child(subtitle)

    var element_row = HBoxContainer.new()
    element_row.alignment = BoxContainer.ALIGNMENT_CENTER
    root.add_child(element_row)

    for element in ["Water", "Fire", "Nature", "Air"]:
        var button = Button.new()
        button.text = element
        button.custom_minimum_size = Vector2(150, 54)
        button.pressed.connect(_on_element_button_pressed.bind(element))
        element_row.add_child(button)
        element_buttons[element] = button

    var gender_row = HBoxContainer.new()
    gender_row.alignment = BoxContainer.ALIGNMENT_CENTER
    root.add_child(gender_row)

    for gender in ["female", "male"]:
        var button = Button.new()
        button.text = gender.capitalize()
        button.custom_minimum_size = Vector2(140, 50)
        button.pressed.connect(_on_gender_button_pressed.bind(gender))
        gender_row.add_child(button)
        gender_buttons[gender] = button

    selected_summary = Label.new()
    selected_summary.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    selected_summary.custom_minimum_size = Vector2(600, 120)
    selected_summary.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    root.add_child(selected_summary)

    var confirm = Button.new()
    confirm.text = "Enter Alfea"
    confirm.custom_minimum_size = Vector2(240, 72)
    confirm.pressed.connect(_on_confirm_pressed)
    root.add_child(confirm)

func _on_element_button_pressed(element_name: String):
    _on_element_selected(element_name)

func _on_gender_button_pressed(gender_type: String):
    _on_gender_selected(gender_type)

func _on_element_selected(element_name: String):
    match element_name:
        "Water":
            GlobalCharacterManager.selected_element_data = water_data
        "Fire":
            GlobalCharacterManager.selected_element_data = fire_data
        "Nature":
            GlobalCharacterManager.selected_element_data = nature_data
        "Air":
            GlobalCharacterManager.selected_element_data = air_data
        _:
            GlobalCharacterManager.selected_element_data = water_data

    _update_summary()

func _on_gender_selected(gender_type: String):
    GlobalCharacterManager.selected_gender = gender_type.to_lower()
    _update_summary()

func _update_summary():
    var data = GlobalCharacterManager.selected_element_data
    if data == null:
        selected_summary.text = "No fairy selected."
        return

    var gender_text = GlobalCharacterManager.selected_gender.capitalize()
    selected_summary.text = "%s %s Fairy\n%s\nFlight: %s   Damage: %s\nSignature color: %s" % [
        gender_text,
        data.fairy_element,
        data.lore_description,
        str(data.base_flight_speed),
        str(data.base_spell_damage),
        data.signature_color.to_html(false)
    ]

func _on_confirm_pressed():
    if GlobalCharacterManager.selected_element_data:
        SaveManager.load_game_data()
        get_tree().change_scene_to_file("res://scenes/world.tscn")
