extends CharacterBody3D

@export var flight_speed: float = 12.0
@export var vertical_speed: float = 8.0
@export var acceleration: float = 5.0

@export var character_skeleton: Skeleton3D
@export var shirt_mesh_instance: MeshInstance3D
@export var gloves_mesh_instance: MeshInstance3D

@export var spell_projectile_scene: PackedScene
@export var cast_spawn_point: Node3D
@export var spell_cooldown_time: float = 0.4

var is_spell_cooldown: bool = false
var joystick_node: Control
var fly_up_btn: Button
var fly_down_btn: Button

@export var clothing_database: Dictionary = {
    "crop_top": null,
    "mesh_gloves": null
}

func _ready():
    GlobalCharacterManager.current_player = self
    _assemble_chosen_character()
    _create_input_fallbacks()
    if not has_node("VisualRoot"):
        var visual_root = Node3D.new()
        visual_root.name = "VisualRoot"
        add_child(visual_root)

func _create_input_fallbacks():
    if not joystick_node:
        var joystick = Control.new()
        joystick.name = "JoystickBackground"
        joystick.position = Vector2(80, 540)
        joystick.size = Vector2(150, 150)
        joystick.set_script(load("res://scripts/ui/virtual_joystick.gd"))
        get_tree().root.add_child(joystick)
        joystick_node = joystick

    if not fly_up_btn:
        var up_btn = Button.new()
        up_btn.name = "FlyUpButton"
        up_btn.position = Vector2(1080, 420)
        up_btn.size = Vector2(120, 120)
        up_btn.text = "UP"
        up_btn.pressed.connect(_on_fly_up_pressed)
        up_btn.released.connect(_on_fly_up_released)
        get_tree().root.add_child(up_btn)
        fly_up_btn = up_btn

    if not fly_down_btn:
        var down_btn = Button.new()
        down_btn.name = "FlyDownButton"
        down_btn.position = Vector2(1080, 560)
        down_btn.size = Vector2(120, 120)
        down_btn.text = "DOWN"
        down_btn.pressed.connect(_on_fly_down_pressed)
        down_btn.released.connect(_on_fly_down_released)
        get_tree().root.add_child(down_btn)
        fly_down_btn = down_btn

func _on_fly_up_pressed():
    pass

func _on_fly_up_released():
    pass

func _on_fly_down_pressed():
    pass

func _on_fly_down_released():
    pass

func _assemble_chosen_character():
    var data = GlobalCharacterManager.selected_element_data
    var gender = GlobalCharacterManager.selected_gender
    if not data:
        return

    flight_speed = data.base_flight_speed
    vertical_speed = data.base_vertical_speed

    if not has_node("VisualRoot"):
        var visual_root = Node3D.new()
        visual_root.name = "VisualRoot"
        add_child(visual_root)

    for child in $VisualRoot.get_children():
        child.queue_free()

    var body_mesh = MeshInstance3D.new()
    body_mesh.mesh = CapsuleMesh.new()
    var body_material = StandardMaterial3D.new()
    body_material.albedo_color = data.signature_color
    body_mesh.material_override = body_material
    $VisualRoot.add_child(body_mesh)

    var shirt_mesh = MeshInstance3D.new()
    shirt_mesh.name = "ShirtMesh"
    shirt_mesh.mesh = BoxMesh.new()
    var shirt_material = StandardMaterial3D.new()
    shirt_material.albedo_color = Color(1.0, 0.9, 1.0, 1.0)
    shirt_mesh.material_override = shirt_material
    $VisualRoot.add_child(shirt_mesh)
    shirt_mesh_instance = shirt_mesh

    var glove_mesh = MeshInstance3D.new()
    glove_mesh.name = "GlovesMesh"
    glove_mesh.mesh = BoxMesh.new()
    var glove_material = StandardMaterial3D.new()
    glove_material.albedo_color = Color(0.95, 0.82, 1.0, 1.0)
    glove_mesh.material_override = glove_material
    $VisualRoot.add_child(glove_mesh)
    gloves_mesh_instance = glove_mesh

    var cast_point = Node3D.new()
    cast_point.name = "CastSpawnPoint"
    cast_point.position = Vector3(0, 1.2, -1.1)
    add_child(cast_point)
    cast_spawn_point = cast_point

    var body_shape = CollisionShape3D.new()
    body_shape.shape = CapsuleShape3D.new()
    body_shape.position = Vector3(0, 1.0, 0)
    add_child(body_shape)

    clothing_database = {
        "crop_top": BoxMesh.new(),
        "mesh_gloves": BoxMesh.new()
    }

func _physics_process(delta):
    var input_dir = Vector2.ZERO
    if joystick_node and joystick_node.has_method("get_joystick_vector"):
        input_dir = joystick_node.get_joystick_vector()
    else:
        input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

    var camera = get_viewport().get_camera_3d()
    if camera:
        var cam_transform = camera.global_transform
        var direction = (cam_transform.basis.z * input_dir.y + cam_transform.basis.x * input_dir.x)
        if direction.length_squared() > 0.01:
            direction = direction.normalized()
            direction.y = 0.0
            direction = direction.normalized()
            velocity.x = lerp(velocity.x, direction.x * flight_speed, acceleration * delta)
            velocity.z = lerp(velocity.z, direction.z * flight_speed, acceleration * delta)
            rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 10.0 * delta)
        else:
            velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
            velocity.z = lerp(velocity.z, 0.0, acceleration * delta)
    else:
        velocity.x = lerp(velocity.x, 0.0, acceleration * delta)
        velocity.z = lerp(velocity.z, 0.0, acceleration * delta)

    var vertical_direction = 0.0
    if fly_up_btn and fly_up_btn.button_pressed:
        vertical_direction += 1.0
    if fly_down_btn and fly_down_btn.button_pressed:
        vertical_direction -= 1.0
    if Input.is_key_pressed(KEY_Q):
        vertical_direction += 1.0
    if Input.is_key_pressed(KEY_E):
        vertical_direction -= 1.0

    velocity.y = lerp(velocity.y, vertical_direction * vertical_speed, acceleration * delta)

    if Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE):
        cast_spell()

    move_and_slide()

func equip_gear(item_id: String):
    if not clothing_database.has(item_id):
        return

    var target_mesh = clothing_database[item_id]
    if "top" in item_id and shirt_mesh_instance and target_mesh != null:
        shirt_mesh_instance.mesh = target_mesh
    elif "gloves" in item_id and gloves_mesh_instance and target_mesh != null:
        gloves_mesh_instance.mesh = target_mesh

func cast_spell():
    if is_spell_cooldown:
        return

    is_spell_cooldown = true
    var orb = ElementalBurst.new()
    orb.global_position = cast_spawn_point.global_position
    orb.direction = -global_transform.basis.z
    orb.damage = GlobalCharacterManager.selected_element_data.base_spell_damage if GlobalCharacterManager.selected_element_data else 15.0
    orb.color = GlobalCharacterManager.selected_element_data.signature_color if GlobalCharacterManager.selected_element_data else Color("#FF9E59")
    get_tree().current_scene.add_child(orb)

    await get_tree().create_timer(spell_cooldown_time).timeout
    is_spell_cooldown = false
