extends Spell

func _process(_delta):
    global_position = Global.player.global_position
    var direction = (get_global_mouse_position() - global_position).normalized()
    rotation = direction.angle()
