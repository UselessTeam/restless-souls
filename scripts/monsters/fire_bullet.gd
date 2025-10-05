extends Node2D

@onready var area2D = $Area2D

func _ready():
    area2D.body_entered.connect(_on_area_body_entered)

func _on_area_body_entered(body):
    if body is Player:
        body.take_damage()
    if body.get_parent() is Monster:
        body.get_parent().take_damage(1)
