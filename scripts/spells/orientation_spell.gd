extends Spell

func _ready():
    super._ready()
    _process(0)

func _process(_delta):
    if self.is_casting:
        return
    global_position = Global.player.global_position
    var direction = (get_global_mouse_position() - global_position).normalized()
    rotation = direction.angle()