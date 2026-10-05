extends CharacterBody3D
class_name BaseEnemy

@export var movement_speed: float = 3.5
@export var attack_damage: float = 10.0
@export var attack_range: float = 2.2
@export var max_health: float = 40.0

var health: float = max_health
var target: Node3D = null
var attack_cooldown: float = 1.0
var attack_elapsed: float = 0.0

func _ready():
    add_to_group("enemies")
    target = GlobalCharacterManager.current_player
    _build_visual()

func _build_visual():
    if has_node("VisualRoot"):
        return
    var visual_root = Node3D.new()
    visual_root.name = "VisualRoot"
    add_child(visual_root)

    var body = MeshInstance3D.new()
    body.mesh = CapsuleMesh.new()
    var mat = StandardMaterial3D.new()
    mat.albedo_color = Color("#E56B6F")
    body.material_override = mat
    visual_root.add_child(body)

func _physics_process(delta):
    if target == null or not is_instance_valid(target):
        target = GlobalCharacterManager.current_player

    if target == null:
        return

    var direction = target.global_position - global_position
    var distance = direction.length()
    direction = direction.normalized() if distance > 0.0001 else Vector3.ZERO

    if distance <= attack_range:
        attack_elapsed -= delta
        if attack_elapsed <= 0.0:
            _attack_target()
            attack_elapsed = attack_cooldown
    else:
        velocity = direction * movement_speed
        if direction != Vector3.ZERO:
            rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), 8.0 * delta)
        move_and_slide()

func _attack_target():
    if target and target.has_method("take_damage"):
        target.take_damage(attack_damage)

func take_damage(amount: float):
    health -= amount
    if health <= 0:
        queue_free()
