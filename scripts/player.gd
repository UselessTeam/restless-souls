extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200
@export var player_sprite_prefab: PackedScene

@onready var animated_sprite = $AnimatedSprite2D

signal spell_cast()

var can_move := true

func _ready():
    Global.player = self
    animated_sprite.animation_finished.connect(_on_attack_animation_finished)

func _process(_delta):
    if not Global.can_player_act():
        return
    var direction = Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed
    var previous_position = position
    move_and_slide()
    if Global.is_battling() and not Global.battle.energy.has_enough_energy(position):
        # TODO: Make a smarter rollback (e.g. slides on the circle)
        position = previous_position
        velocity = Vector2.ZERO


func _unhandled_input(event):
    if not Global.can_player_act():
        return
    if event.is_action_pressed("action_use") \
                && Global.is_battling() \
                && Global.battle.is_player_turn:
        spell_cast.emit()
        animated_sprite.play("attack")

func _on_attack_animation_finished():
    if (animated_sprite.animation == "attack"):
        animated_sprite.play("idle")

func take_damage():
    print("Player took damage")
