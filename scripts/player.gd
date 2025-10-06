extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200
@export var player_sprite_prefab: PackedScene

@onready var animated_sprite = $AnimatedSprite2D
@onready var animation_player = $AnimationPlayer

var can_move := true

func _ready():
    if not Global.player:
        Global.player = self
        if not Global.has_checkpoint:
            Global.last_checkpoint = position
    animated_sprite.animation_finished.connect(_on_attack_animation_finished)
    animation_player.play("hover")
    animated_sprite.frame = 1

func _process(_delta):
    if not Global.can_player_act():
        return
    var direction = Input.get_vector("left", "right", "up", "down")
    velocity = direction * speed
    if (abs(direction.x) > 0.1):
        face_direction(direction.x < 0)

    move_and_slide()
    if Global.is_battling() and not Global.battle.energy.has_enough_energy_for_position(position):
        position = Global.battle.energy.project_to_reachable_position(position)

func _unhandled_input(event):
    if not Global.can_player_act():
        return
    if event.is_action_pressed("action_use") \
                && Global.is_battling() \
                && Global.can_player_act():
        var real_action = Global.battle.do_player_action()
        if real_action:
            animated_sprite.play("attack")
    elif event.is_action_pressed("toggle_left"):
        Global.battle.spell_bar.toggle_spell(-1)
    elif event.is_action_pressed("toggle_right"):
        Global.battle.spell_bar.toggle_spell(1)

func _on_attack_animation_finished():
    if (animated_sprite.animation == "attack"):
        animated_sprite.play("idle")

func take_damage():
    Global.battle.health.health -= 1


func face_direction(is_left) -> void:
    animated_sprite.scale.x = abs(animated_sprite.scale.x) * (-1 if is_left else 1)

func get_scythe():
    animated_sprite.frame = 0

func check_end_game():
    if Global.progress.is_game_done():
        $Camera2D.open_finish_screen()
