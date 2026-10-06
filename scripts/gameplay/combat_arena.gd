extends Node3D

@export var wave_size: int = 6
@export var boss_health: float = 200.0
var current_wave: int = 1
var enemies_defeated: int = 0
var player: CharacterBody3D = null
var ui_root: CanvasLayer = null

func _ready():
    _setup_arena()
    _spawn_player()
    _setup_combat_ui()
    _spawn_wave(current_wave)

func _setup_arena():
    # Environment
    var environment = WorldEnvironment.new()
    var env = Environment.new()
    var sky_material = ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color("#4A0E4E")
    sky_material.sky_horizon_color = Color("#8B2E6B")
    sky_material.ground_horizon_color = Color("#4A0E4E")
    sky_material.sun_color = Color("#FF6B35")
    sky_material.sun_angle_max = 45.0

    var sky = Sky.new()
    sky.sky_material = sky_material
    env.sky = sky
    env.background_mode = Environment.BG_SKY
    env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    env.ambient_light_color = Color("#8B4789")
    env.ambient_light_energy = 0.8
    environment.environment = env
    add_child(environment)

    var sun = DirectionalLight3D.new()
    sun.position = Vector3(15, 18, 10)
    sun.rotation_degrees = Vector3(-45, 45, 0)
    sun.light_color = Color("#FF6B35")
    sun.light_energy = 2.0
    add_child(sun)

    # Arena ground
    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(100, 100)
    ground.mesh = plane
    ground.position = Vector3(0, -1, 0)
    var ground_material = StandardMaterial3D.new()
    ground_material.albedo_color = Color("#2D1B4E")
    ground.material_override = ground_material
    add_child(ground)

    # Combat zone barrier
    var barrier = MeshInstance3D.new()
    barrier.name = "ArenaBarrier"
    barrier.mesh = TorusMesh.new()
    barrier.position = Vector3(0, 1.0, 0)
    var barrier_mat = StandardMaterial3D.new()
    barrier_mat.albedo_color = Color("#FFB6C1")
    barrier_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
    barrier_mat.alpha_scissor = BaseMaterial3D.ALPHA_SCISSOR_OPAQUE
    barrier.material_override = barrier_mat
    add_child(barrier)

func _spawn_player():
    player = CharacterBody3D.new()
    player.name = "FairyPlayer"
    player.position = Vector3(0, 1.0, 0)
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

    player.max_health = 150.0
    player.current_health = player.max_health

func _spawn_wave(wave_num: int):
    var enemy_count = 3 + (wave_num * 2)
    for i in range(enemy_count):
        var enemy = CharacterBody3D.new()
        enemy.name = "WaveEnemy_%d" % i
        var angle = (TAU / enemy_count) * i
        enemy.position = Vector3(cos(angle) * 15.0, 1.0, sin(angle) * 15.0)
        enemy.set_script(load("res://scripts/character/base_enemy.gd"))
        add_child(enemy)

        var collision = CollisionShape3D.new()
        collision.shape = CapsuleShape3D.new()
        collision.position = Vector3(0, 1.0, 0)
        enemy.add_child(collision)

        var mesh = MeshInstance3D.new()
        mesh.mesh = CapsuleMesh.new()
        var material = StandardMaterial3D.new()
        material.albedo_color = Color("#E56B6F") if wave_num % 2 == 0 else Color("#FF8C42")
        mesh.material_override = material
        enemy.add_child(mesh)

func _setup_combat_ui():
    ui_root = CanvasLayer.new()
    add_child(ui_root)

    var hud = Control.new()
    hud.name = "CombatHUD"
    hud.set_anchors_preset(Control.PRESET_FULL_RECT)
    ui_root.add_child(hud)

    # Wave counter
    var wave_label = Label.new()
    wave_label.name = "WaveLabel"
    wave_label.position = Vector2(20, 20)
    wave_label.add_theme_font_size_override("font_size", 28)
    wave_label.text = "Wave: %d" % current_wave
    hud.add_child(wave_label)

    # Enemy counter
    var enemy_label = Label.new()
    enemy_label.name = "EnemyLabel"
    enemy_label.position = Vector2(20, 60)
    enemy_label.add_theme_font_size_override("font_size", 20)
    enemy_label.text = "Enemies: %d" % _count_enemies()
    hud.add_child(enemy_label)

    # Health bar
    var health_bar = ProgressBar.new()
    health_bar.name = "PlayerHealthBar"
    health_bar.position = Vector2(20, 100)
    health_bar.size = Vector2(300, 30)
    health_bar.value = 100.0
    health_bar.max_value = 100.0
    hud.add_child(health_bar)

    # Spell cooldown indicator
    var cooldown_label = Label.new()
    cooldown_label.name = "CooldownLabel"
    cooldown_label.position = Vector2(1080, 650)
    cooldown_label.add_theme_font_size_override("font_size", 18)
    cooldown_label.text = "SPELL READY"
    hud.add_child(cooldown_label)

func _count_enemies() -> int:
    return get_tree().get_nodes_in_group("enemies").size()

func _physics_process(_delta):
    if _count_enemies() == 0 and current_wave < 5:
        current_wave += 1
        _spawn_wave(current_wave)
        if ui_root and ui_root.has_node("CombatHUD/WaveLabel"):
            ui_root.get_node("CombatHUD/WaveLabel").text = "Wave: %d" % current_wave
