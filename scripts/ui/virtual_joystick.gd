extends Control

var joystick_center: Vector2 = Vector2.ZERO
var joystick_radius: float = 60.0
var joystick_vector: Vector2 = Vector2.ZERO
var is_pressed: bool = false

func _ready():
    joystick_center = size / 2.0
    gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
    if event is InputEventMouseButton:
        is_pressed = event.pressed
        if not is_pressed:
            joystick_vector = Vector2.ZERO
    elif event is InputEventMouseMotion and is_pressed:
        var delta = event.position - joystick_center
        if delta.length() > joystick_radius:
            delta = delta.normalized() * joystick_radius
        joystick_vector = delta / joystick_radius

func get_joystick_vector() -> Vector2:
    return joystick_vector

func _draw():
    # Outer circle
    draw_circle(joystick_center, joystick_radius, Color(1, 1, 1, 0.3))
    # Inner stick
    var stick_pos = joystick_center + joystick_vector * (joystick_radius * 0.6)
    draw_circle(stick_pos, joystick_radius * 0.3, Color(0.8, 0.6, 1.0, 0.8))

func _process(_delta):
    queue_redraw()
