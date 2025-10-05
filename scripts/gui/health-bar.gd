extends MarginContainer

class_name HealthBar

const DEAD_ZONE: float = 4.0

@export var health_on: Texture2D
@export var health_off: Texture2D

@onready var beads: Node = $List

var player_last_position: Vector2 = Vector2.ZERO

var max_health: int = 0:
    set(value):
        if max_health != value:
            max_health = max(value, 1)

var health: int = max_health:
    set(value):
        health = clamp(value, 0, max_health)
        update_health_display()

func start_battle():
    max_health = Global.progress.get_max_health()
    health = max_health

func update_health_display():
    while beads.get_child_count() < max_health:
        var bead = TextureRect.new()
        bead.name = "Bead-%d" % (beads.get_child_count() + 1)
        beads.add_child(bead)
    for delete_index in range(max_health, beads.get_child_count()):
        beads.get_child(delete_index).queue_free()

    for i in range(max_health):
        var bead: TextureRect = beads.get_child(i)
        bead.texture = health_on if i < health else health_off
