extends Monster
class_name Shoot

@export var ideal_distance_min := 400
@export var ideal_distance_max := 500
@export var travel_distance := 200

@export var bullet: PackedScene

const BULLET_TRAVEL_TIME := 0.3

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    var dist = toPlayer.length()

    var target_dist = dist
    if dist < ideal_distance_min:
        target_dist = min(dist + travel_distance, ideal_distance_min)
    elif dist > ideal_distance_max:
        target_dist = max(dist - travel_distance, ideal_distance_max)
    var time = TURN_TIME if target_dist != dist else 0.0

    face_direction(dir.x * (dist - target_dist) < 0)

    var dir_sign = (dir * (dist - target_dist)).normalized()
    var distance = get_collision_distance(global_position, dir_sign, abs((dist - target_dist)))

    var tween = create_tween() \
        .tween_property(self, "position", position + dir_sign * distance, time)
    if (target_dist >= ideal_distance_min && target_dist <= ideal_distance_max):
        await tween.finished
        await shoot()
    else:
        await tween.finished

func shoot():
    play_sound()
    face_direction(Global.player.global_position.x - global_position.x < 0)
    var bullet_node = bullet.instantiate()
    get_tree().root.add_child(bullet_node)
    bullet_node.position = global_position
    await create_tween() \
        .tween_property(bullet_node, "global_position", Global.player.global_position, BULLET_TRAVEL_TIME) \
        .finished
    if bullet_node:
        bullet_node.queue_free()
        Global.player.take_damage()

func get_collision_distance(origin: Vector2, direction: Vector2, max_distance: float) -> float:
    var space_state = get_world_2d().direct_space_state
    
    var query = PhysicsRayQueryParameters2D.create(
        origin,
        origin + direction.normalized() * max_distance
    )
    
    var result = space_state.intersect_ray(query)
    
    if result:
        return origin.distance_to(result.position)
    else:
        return max_distance