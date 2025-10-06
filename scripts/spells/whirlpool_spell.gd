extends Spell

const N_POINTS := 100

@onready var particles = $CPUParticles2D

@export_range(0.0, 1.0) var pushAmount = 0.6
@export var maxDistance = 750

func _ready():
    var points: Array[Vector2] = []
    for i in range(N_POINTS + 1):
        points.append(Vector2(0, 100).rotated(i * TAU / N_POINTS))

    for i in range(N_POINTS + 1):
        points.append(Vector2(0, 50).rotated((N_POINTS + 1 - i) * TAU / N_POINTS))
    visual_polygon.polygon = points

    var particle_points: Array[Vector2] = []
    for i in range(N_POINTS + 1):
        particle_points.append(Vector2(0, 100).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 95).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 90).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 85).rotated(i * TAU / N_POINTS))
    particles.emission_points = particle_points

    super._ready()
    _process(0)

func _process(delta):
    if is_casting:
        return
    global_position = Global.player.global_position
    var direction = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
    if (direction != Vector2.ZERO):
        scale *= exp(-direction.y * delta)

func _input(event):
    if event is InputEventMouseMotion:
        var distance = (get_global_mouse_position() - global_position).length()
        distance = min(maxDistance, distance)
        scale = Vector2.ONE * distance / 100.0


func effect(monster):
    create_tween().tween_property(monster, "global_position", \
            Global.player.global_position * pushAmount + monster.global_position * (1 - pushAmount), \
            animation_player.current_animation_length * 0.8) \
        .set_trans(Tween.TRANS_QUAD) \
        .set_ease(Tween.EASE_IN)
