extends Area2D

class_name Spell

@onready var collision_shape = $CollisionShape2D
@onready var visual_polygon = $Polygon2D

var hinted_monsters: Array[Monster] = []

func _ready():
    var collision_polygon = collision_shape.shape as ConvexPolygonShape2D
    collision_polygon.points = visual_polygon.polygon

    body_entered.connect(_on_area_body_entered)
    body_exited.connect(_on_area_body_exited)

func _exit_tree():
    for monster in hinted_monsters:
        unhint(monster)

func _on_area_body_entered(body):
    if body.get_parent() is Monster:
        hint(body.get_parent())

func _on_area_body_exited(body):
    if body.get_parent() is Monster:
        unhint(body.get_parent())

func hint(monster: Monster):
    if monster in hinted_monsters:
        return
    monster.highlight()
    hinted_monsters.append(monster)

func unhint(monster: Monster):
    if monster not in hinted_monsters:
        return
    monster.unhighlight()
    hinted_monsters.erase(monster)


func _start_hinting():
    pass
