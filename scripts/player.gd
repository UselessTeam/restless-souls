extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200
@export var player_sprite_prefab: PackedScene
@export var max_health := 10
var health := max_health

@onready var animated_sprite = $AnimatedSprite2D

var can_move := true

func _ready():
    Global.player = self
    animated_sprite.animation_finished.connect(_on_attack_animation_finished)

func _process(_delta):
    if not Global.can_player_act():
        return
    var direction = Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed
    move_and_slide()
    if Global.is_battling() and not Global.battle.energy.has_enough_energy(position):
        position = Global.battle.energy.project_to_reachable_position(position)


func _unhandled_input(event):
    if not Global.can_player_act():
        return
    if event.is_action_pressed("action_use") \
                && Global.is_battling() \
                && Global.battle.is_player_turn:
        Global.battle.do_player_action()
        animated_sprite.play("attack")

func _on_attack_animation_finished():
    if (animated_sprite.animation == "attack"):
        animated_sprite.play("idle")

func take_damage():
    print("Player took damage")
