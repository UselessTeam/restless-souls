extends Spell

func _process(_delta):
    var direction = (get_global_mouse_position() - global_position).normalized()
    rotation = direction.angle()
