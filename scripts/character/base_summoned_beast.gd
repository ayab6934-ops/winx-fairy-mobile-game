extends CharacterBody3D
class_name BaseSummonedBeast

@export var movement_speed: float = 6.0
@export var attack_damage: float = 12.0
@export var attack_cooldown: float = 1.5
@export var lifetime_duration: float = 12.0

var current_target: CharacterBody3D = null
var is_attack_ready: bool = true
var attack_timer: float = 0.0

func _ready():
    add_to_group("summons")
    call_deferred("_find_closest_enemy")
    get_tree().create_timer(lifetime_duration).timeout.connect(queue_free)

func _physics_process(delta):
    if current_target == null or not is_instance_valid(current_target):
        _find_closest_enemy()
        if current_target == null:
            return

    var to_target = current_target.global_position - global_position
    var distance = to_target.length()
    if distance <= 1.8:
        if is_attack_ready:
            _attack()
        return

    var dir = to_target.normalized()
    velocity = dir * movement_speed
    if dir != Vector3.ZERO:
        rotation.y = lerp_angle(rotation.y, atan2(-dir.x, -dir.z), 8.0 * delta)
    move_and_slide()

func _find_closest_enemy():
    var enemies = get_tree().get_nodes_in_group("enemies")
    var closest_d = INF
    for enemy in enemies:
        if enemy and is_instance_valid(enemy):
            var distance = global_position.distance_to(enemy.global_position)
            if distance < closest_d:
                closest_d = distance
                current_target = enemy

func _attack():
    is_attack_ready = false
    if current_target and current_target.has_method("take_damage"):
        current_target.take_damage(attack_damage)
    await get_tree().create_timer(attack_cooldown).timeout
    is_attack_ready = true
