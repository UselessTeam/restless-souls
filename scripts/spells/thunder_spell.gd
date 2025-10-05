extends Spell

const N_POINTS := 100

@export var RADIUS := 200

func _ready():
    var points: Array[Vector2] = []
    for i in range(N_POINTS):
        points.append(Vector2(0, 200).rotated(i * TAU / N_POINTS))
    visual_polygon.polygon = points

    super._ready()
    _process(0)

func _process(_delta):
    if is_casting:
        return
    global_position = get_global_mouse_position()
