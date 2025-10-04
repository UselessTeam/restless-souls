extends Monster

var travel_distance := 200

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    if (abs(toPlayer.length() - travel_distance) < 50):
        dir *= 1.3
    face_direction(dir.x < 0)
    await create_tween() \
        .tween_property(self, "position", position + dir * travel_distance, turn_time) \
        .finished

func _ready():
    attack_area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
    if body is Player:
        body.take_damage()
