extends Area2D

func _ready():
    body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
    if body is Player:
        body.take_damage()
        get_parent().queue_free()
