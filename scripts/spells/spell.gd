extends Area2D

class_name Spell

@onready var collision_shape = $CollisionShape2D
@onready var visual_polygon = $Polygon2D

func _ready():
    var collision_polygon = collision_shape.shape as ConvexPolygonShape2D
    collision_polygon.points = visual_polygon.polygon

    body_entered.connect(_on_area_body_entered)


func _on_area_body_entered(body):
    if body.get_parent() is Monster:
        print("Monster entered spell area")