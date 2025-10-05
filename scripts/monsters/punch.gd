extends Monster

class_name Punch

var travel_distance := 200

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    if (abs(toPlayer.length() - travel_distance) < 50):
        dir *= 1.3
    face_direction(dir.x < 0)

    if (toPlayer.length() < travel_distance):
        play_sound()

    play_attack_animation()
    await create_tween() \
        .tween_property(self, "position", position + dir * travel_distance, TURN_TIME) \
        .set_trans(Tween.TRANS_QUART) \
        .finished

func _ready():
    attack_area.body_entered.connect(_on_area_body_entered)
    super._ready()

func _on_area_body_entered(body):
    if body is Player:
        body.take_damage()

func play_attack_animation():
    animation_player.play("attack")
    await animation_player.animation_finished
    animation_player.play("hover")