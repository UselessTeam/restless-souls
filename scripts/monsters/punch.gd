extends Monster

var travel_distance := 100

func act_turn():
    var toPlayer = (Global.player.global_position - global_position)
    var dir = toPlayer.normalized()
    if (abs(toPlayer.length() - travel_distance) < 10):
        dir *= 1.3
    create_tween() \
        .tween_property(self, "position", position + dir * travel_distance, turn_time)

@onready var area = $Area2D

func _ready():
    area.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
    if body is Player:
        print("Player entered monster area")
