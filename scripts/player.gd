extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200

@onready var animated_sprite = $AnimatedSprite2D

signal spell_cast()

var can_move := true

func _ready():
    Global.player = self
    animated_sprite.animation_finished.connect(_on_attack_animation_finished)

func _process(_delta):
    if !can_move:
        return
    var direction = Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed
    move_and_slide()


func _unhandled_input(event):
    if !can_move:
        return
    if event.is_action_pressed("action_use") \
                && Global.is_battling() \
                && !Global.current_battle_area.is_monster_turn:
        spell_cast.emit()
        animated_sprite.play("attack")
        can_move = false

func spell_finished():
    can_move = true
    Global.battle.spell_bar.reset_spell()

func _on_attack_animation_finished():
    if (animated_sprite.animation == "attack"):
        animated_sprite.play("idle")
