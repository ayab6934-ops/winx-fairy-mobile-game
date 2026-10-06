extends Node3D

var player: CharacterBody3D = null
var current_dorm: String = "girls"
var ui_root: CanvasLayer = null

func _ready():
    _setup_hub_world()
    _setup_ui_hud()
    _spawn_player()
    _spawn_npc_specialists()
    _create_dorm_teleporters()

func _setup_hub_world():
    # World environment
    var environment = WorldEnvironment.new()
    var env = Environment.new()
    var sky_material = ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color("#D1A3FF")
    sky_material.sky_horizon_color = Color("#FF9E59")
    sky_material.ground_horizon_color = Color("#D1A3FF")
    sky_material.sun_color = Color("#FFD7A8")
    sky_material.sun_angle_max = 60.0

    var sky = Sky.new()
    sky.sky_material = sky_material
    env.sky = sky
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_color = Color("#FFE8F8")
    env.ambient_light_energy = 0.9
    environment.environment = env
    add_child(environment)

    var sun = DirectionalLight3D.new()
    sun.position = Vector3(12, 20, 10)
    sun.rotation_degrees = Vector3(-55, 35, 0)
    sun.light_color = Color("#FF9E59")
    sun.light_energy = 2.5
    add_child(sun)

    # Terrain
    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(120, 120)
    ground.mesh = plane
    ground.position = Vector3(0, -1, 0)
    var ground_material = StandardMaterial3D.new()
    ground_material.albedo_color = Color("#7BC4B5")
    ground.material_override = ground_material
    add_child(ground)

    # Central academy building
    var academy = MeshInstance3D.new()
    var academy_mesh = BoxMesh.new()
    academy_mesh.size = Vector3(30, 16, 20)
    academy.mesh = academy_mesh
    academy.position = Vector3(0, 8, -15)
    var academy_mat = StandardMaterial3D.new()
    academy_mat.albedo_color = Color("#E8D5FF")
    academy.material_override = academy_mat
    add_child(academy)

    # Girls dorm (left)
    var girls_dorm = MeshInstance3D.new()
    var girls_mesh = BoxMesh.new()
    girls_mesh.size = Vector3(18, 14, 16)
    girls_dorm.mesh = girls_mesh
    girls_dorm.position = Vector3(-28, 7, 8)
    var girls_mat = StandardMaterial3D.new()
    girls_mat.albedo_color = Color("#FFD7E8")
    girls_dorm.material_override = girls_mat
    add_child(girls_dorm)

    # Boys dorm (right)
    var boys_dorm = MeshInstance3D.new()
    var boys_mesh = BoxMesh.new()
    boys_mesh.size = Vector3(18, 14, 16)
    boys_dorm.mesh = boys_mesh
    boys_dorm.position = Vector3(28, 7, 8)
    var boys_mat = StandardMaterial3D.new()
    boys_mat.albedo_color = Color("#B8E1FF")
    boys_dorm.material_override = boys_mat
    add_child(boys_dorm)

    # Combat training grounds (bottom center)
    var training_zone = MeshInstance3D.new()
    var training_mesh = BoxMesh.new()
    training_mesh.size = Vector3(40, 0.5, 30)
    training_zone.mesh = training_mesh
    training_zone.position = Vector3(0, 0, 25)
    var training_mat = StandardMaterial3D.new()
    training_mat.albedo_color = Color("#D4A373")
    training_zone.material_override = training_mat
    add_child(training_zone)

func _spawn_player():
    player = CharacterBody3D.new()
    player.name = "FairyPlayer"
    player.position = Vector3(0, 1.0, 2)
    player.set_script(load("res://scripts/character/fairy_flight_controller.gd"))
    add_child(player)

    var collision_shape = CollisionShape3D.new()
    collision_shape.shape = CapsuleShape3D.new()
    collision_shape.position = Vector3(0, 1.0, 0)
    player.add_child(collision_shape)

    var visual_root = Node3D.new()
    visual_root.name = "VisualRoot"
    player.add_child(visual_root)

    var body = MeshInstance3D.new()
    body.mesh = CapsuleMesh.new()
    var mat = StandardMaterial3D.new()
    if GlobalCharacterManager.selected_element_data:
        mat.albedo_color = GlobalCharacterManager.selected_element_data.signature_color
    else:
        mat.albedo_color = Color("#F7B7FF")
    body.material_override = mat
    visual_root.add_child(body)

    var cast_spawn = Node3D.new()
    cast_spawn.name = "CastSpawnPoint"
    cast_spawn.position = Vector3(0, 1.2, -1.2)
    player.add_child(cast_spawn)

func _spawn_npc_specialists():
    var specialists = [
        {"name": "Griselda", "role": "Armory Master", "pos": Vector3(-10, 1.0, -20)},
        {"name": "Saladina", "role": "Headmistress", "pos": Vector3(0, 1.0, -8)},
        {"name": "Wizards Hall", "role": "Hybrid Training", "pos": Vector3(12, 1.0, -20)}
    ]

    for spec in specialists:
        var npc = MeshInstance3D.new()
        npc.name = spec["name"]
        npc.mesh = CapsuleMesh.new()
        npc.position = spec["pos"]
        var mat = StandardMaterial3D.new()
        mat.albedo_color = Color("#9B7EBD")
        npc.material_override = mat
        add_child(npc)

func _create_dorm_teleporters():
    # Girls dorm teleporter
    var girls_tp = Area3D.new()
    girls_tp.name = "GirlsDormTP"
    girls_tp.position = Vector3(-28, 1.0, 8)
    var girls_shape = CollisionShape3D.new()
    girls_shape.shape = SphereShape3D.new()
    girls_shape.shape.radius = 3.0
    girls_tp.add_child(girls_shape)
    girls_tp.body_entered.connect(_on_dorm_entered.bindv(["girls"]))
    add_child(girls_tp)

    # Boys dorm teleporter
    var boys_tp = Area3D.new()
    boys_tp.name = "BoysDormTP"
    boys_tp.position = Vector3(28, 1.0, 8)
    var boys_shape = CollisionShape3D.new()
    boys_shape.shape = SphereShape3D.new()
    boys_shape.shape.radius = 3.0
    boys_tp.add_child(boys_shape)
    boys_tp.body_entered.connect(_on_dorm_entered.bindv(["boys"]))
    add_child(boys_tp)

func _on_dorm_entered(body: Node, dorm_type: String):
    if body == player:
        current_dorm = dorm_type
        _show_dorm_interior()

func _show_dorm_interior():
    print("Entering %s dorm..." % current_dorm)
    # Future: load dorm scene or swap viewport

func _setup_ui_hud():
    ui_root = CanvasLayer.new()
    add_child(ui_root)

    var hud = Control.new()
    hud.name = "HUD"
    hud.set_anchors_preset(Control.PRESET_FULL_RECT)
    ui_root.add_child(hud)

    # Dust counter (top left)
    var dust_label = Label.new()
    dust_label.name = "DustCounter"
    dust_label.position = Vector2(20, 20)
    dust_label.add_theme_font_size_override("font_size", 24)
    dust_label.text = "Dust: 0"
    hud.add_child(dust_label)

    # Inventory button (top right)
    var inv_btn = Button.new()
    inv_btn.name = "InventoryButton"
    inv_btn.position = Vector2(1200, 20)
    inv_btn.size = Vector2(60, 60)
    inv_btn.text = "INV"
    inv_btn.pressed.connect(_on_inventory_pressed)
    hud.add_child(inv_btn)

    # Status bar (top center)
    var status = Label.new()
    status.name = "StatusLabel"
    status.position = Vector2(600, 20)
    status.text = "Welcome to Alfea Academy"
    status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    status.add_theme_font_size_override("font_size", 18)
    hud.add_child(status)

    InventoryManager.inventory_updated.connect(_on_inventory_updated)
    _on_inventory_updated()

func _on_inventory_updated():
    if ui_root and ui_root.has_node("HUD/DustCounter"):
        ui_root.get_node("HUD/DustCounter").text = "Dust: %d" % InventoryManager.magical_dust_count

func _on_inventory_pressed():
    print("Inventory opened: Fashion=%s, Food=%s, Dust=%d" % [
        InventoryManager.fashion_inventory.size(),
        InventoryManager.food_inventory.size(),
        InventoryManager.magical_dust_count
    ])
