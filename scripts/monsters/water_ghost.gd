extends Punch

class_name WaterGhost

@export var attack_distance := 200

@onready var whirlpool = $WhirlpoolAttack

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    face_direction(dir.x < 0)
    await create_tween() \
        .tween_property(self, "position", position + toPlayer - toPlayer.normalized() * attack_distance, TURN_TIME) \
        .finished
    play_sound()
    await whirlpool.attack(global_position)
