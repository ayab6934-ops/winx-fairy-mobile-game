extends Resource
class_name FairyCharacterData

@export_group("Identity")
@export var fairy_name: String = ""
@export_enum("Water", "Fire", "Nature", "Air") var fairy_element: String = "Water"
@export_multiline var lore_description: String = ""

@export_group("Gameplay Stats")
@export var base_flight_speed: float = 12.0
@export var base_vertical_speed: float = 8.0
@export var base_spell_damage: float = 15.0

@export_group("Gendered Models")
@export var female_base_mesh: PackedScene
@export var male_base_mesh: PackedScene

@export_group("Visual FX")
@export var signature_color: Color = Color.WHITE
