extends Spell

func _ready():
    super._ready()
    _process(0)

func _process(_delta):
    if self.is_casting:
        return
    global_position = Global.player.global_position
    var direction = Input.get_vector("rightstick_left", "rightstick_right", "rightstick_up", "rightstick_down")
    if (direction == Vector2.ZERO):
        rotation = direction.angle()

func _input(event):
    if event is InputEventMouseMotion:
        rotation = (get_global_mouse_position() - global_position).angle()