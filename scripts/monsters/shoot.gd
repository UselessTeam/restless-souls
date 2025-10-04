extends Monster

@export var ideal_distance_min := 350
@export var ideal_distance_max := 600
@export var travel_distance := 200

@export var bullet: PackedScene

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    var dist = toPlayer.length()

    var target_dist = dist
    if dist < ideal_distance_min:
        target_dist = min(dist + travel_distance, ideal_distance_min)
    elif dist > ideal_distance_max:
        target_dist = max(dist - travel_distance, ideal_distance_max)
    var time = turn_time if target_dist != dist else 0
    var tween = create_tween() \
        .tween_property(self, "position", position + dir * (dist - target_dist), time)
    if (target_dist >= ideal_distance_min && target_dist <= ideal_distance_max):
        await tween.finished
        await shoot()
    await tween.finished

func shoot():
    var bullet_node = bullet.instantiate()
    get_tree().root.add_child(bullet_node)
    bullet_node.position = global_position
    await create_tween() \
        .tween_property(bullet_node, "global_position", Global.player.global_position, 0.3) \
        .finished
