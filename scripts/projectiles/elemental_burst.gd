extends Area3D
class_name ElementalBurst

var direction: Vector3 = Vector3.FORWARD
var speed: float = 18.0
var damage: float = 15.0
var color: Color = Color("#FF9E59")
var lifetime: float = 2.5

func _ready():
    var mesh = SphereMesh.new()
    var material = StandardMaterial3D.new()
    material.albedo_color = color
    material.emission_enabled = true
    material.emission = color
    material.emission_energy_multiplier = 1.8

    var body = MeshInstance3D.new()
    body.mesh = mesh
    body.material_override = material
    add_child(body)

    var shape = CollisionShape3D.new()
    shape.shape = SphereShape3D.new()
    shape.shape.radius = 0.45
    add_child(shape)

    body_entered.connect(_on_body_entered)
    get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta):
    position += direction * speed * delta

func _on_body_entered(body):
    if body.has_method("take_damage"):
        body.take_damage(damage)
    queue_free()
