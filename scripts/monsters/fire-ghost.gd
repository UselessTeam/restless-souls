extends Shoot

func shoot():
    var shoot_to = (Global.player.global_position - global_position).normalized()
    face_direction(shoot_to.x < 0)
    play_sound()


    var bullet_node = bullet.instantiate()
    get_tree().root.add_child(bullet_node)
    bullet_node.position = global_position
    get_tree().create_timer(0.6).timeout.connect(bullet_node.queue_free)

    await create_tween() \
        .tween_property(bullet_node, "global_position", global_position + shoot_to * 4000, 0.6) \
        .finished
