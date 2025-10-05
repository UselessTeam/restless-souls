extends Spell

const N_POINTS := 100

@onready var particles = $ParticleCenter/CPUParticles2Dwhite
func _ready():
    var points: Array[Vector2] = []
    for i in range(N_POINTS+1):
        points.append(Vector2(0, 100).rotated(i * TAU / N_POINTS))

    for i in range(N_POINTS+1):
        points.append(Vector2(0, 50).rotated((N_POINTS + 1 - i) * TAU / N_POINTS))
    visual_polygon.polygon = points

    var particle_points: Array[Vector2] = []
    for i in range(N_POINTS+1):
        particle_points.append(Vector2(0, 100).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 95).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 90).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 85).rotated(i * TAU / N_POINTS))
    particles.emission_points = particle_points

    super._ready()
    _process(0)

func _process(_delta):
    if was_cast:
        return
    global_position = Global.player.global_position
    var direction = (get_global_mouse_position() - global_position).length()
    scale = Vector2.ONE * direction / 100.0
