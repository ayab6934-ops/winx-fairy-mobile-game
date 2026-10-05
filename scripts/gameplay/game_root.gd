extends Node3D

@export var enemy_count: int = 6
var spawn_positions: Array = []

func _ready():
    _setup_world()
    _spawn_player()
    _spawn_enemies()

func _setup_world():
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
    sun.position = Vector3(8, 16, 8)
    sun.rotation_degrees = Vector3(-55, 35, 0)
    sun.light_color = Color("#FF9E59")
    sun.light_energy = 2.5
    add_child(sun)

    var ground = MeshInstance3D.new()
    var plane = PlaneMesh.new()
    plane.size = Vector2(80, 80)
    ground.mesh = plane
    ground.position = Vector3(0, -1, 0)
    var ground_material = StandardMaterial3D.new()
    ground_material.albedo_color = Color("#7BC4B5")
    ground.material_override = ground_material
    add_child(ground)

    var walkway = MeshInstance3D.new()
    var walkway_mesh = BoxMesh.new()
    walkway_mesh.size = Vector3(10, 0.4, 10)
    walkway.mesh = walkway_mesh
    walkway.position = Vector3(0, 0.05, 0)
    var walkway_material = StandardMaterial3D.new()
    walkway_material.albedo_color = Color("#E2D5FF")
    walkway.material_override = walkway_material
    add_child(walkway)

func _spawn_player():
    var player = CharacterBody3D.new()
    player.name = "FairyPlayer"
    player.position = Vector3(0, 1.0, 6)
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
    mat.albedo_color = Color("#F7B7FF")
    body.material_override = mat
    visual_root.add_child(body)

    var shirt = MeshInstance3D.new()
    shirt.name = "ShirtMesh"
    shirt.mesh = BoxMesh.new()
    var shirt_mat = StandardMaterial3D.new()
    shirt_mat.albedo_color = Color("#FFB3D9")
    shirt.material_override = shirt_mat
    visual_root.add_child(shirt)

    var gloves = MeshInstance3D.new()
    gloves.name = "GlovesMesh"
    gloves.mesh = BoxMesh.new()
    var glove_mat = StandardMaterial3D.new()
    glove_mat.albedo_color = Color("#D1A3FF")
    gloves.material_override = glove_mat
    visual_root.add_child(gloves)

    var cast_spawn = Node3D.new()
    cast_spawn.name = "CastSpawnPoint"
    cast_spawn.position = Vector3(0, 1.2, -1.2)
    player.add_child(cast_spawn)

    player.cast_spawn_point = cast_spawn
    player.spell_projectile_scene = null

func _spawn_enemies():
    for index in range(enemy_count):
        var enemy = CharacterBody3D.new()
        enemy.name = "Enemy_%d" % index
        enemy.position = Vector3(randf_range(-18.0, 18.0), 1.0, randf_range(-18.0, 18.0))
        enemy.set_script(load("res://scripts/character/base_enemy.gd"))
        add_child(enemy)

        var collision = CollisionShape3D.new()
        collision.shape = CapsuleShape3D.new()
        collision.position = Vector3(0, 1.0, 0)
        enemy.add_child(collision)

        var mesh = MeshInstance3D.new()
        mesh.mesh = CapsuleMesh.new()
        var material = StandardMaterial3D.new()
        material.albedo_color = Color("#E56B6F")
        mesh.material_override = material
        enemy.add_child(mesh)
