extends Area2D

class_name Spell

@onready var collision_shape = $CollisionShape2D
@onready var visual_polygon = $Polygon2D
@onready var animation_player = $AnimationPlayer

var hinted_monsters: Array[Monster] = []

func _ready():
    var collision_polygon = collision_shape.shape as ConvexPolygonShape2D
    collision_polygon.points = visual_polygon.polygon

    body_entered.connect(_on_area_body_entered)
    body_exited.connect(_on_area_body_exited)
    animation_player.animation_finished.connect(_on_animation_finished)

    Global.player.spell_cast.connect(cast_spell)

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

func cast_spell():
    for monster in hinted_monsters:
        monster.damage()
    visual_polygon.queue_free()
    animation_player.play("cast")

func _on_animation_finished(_anim_name):
    queue_free()
