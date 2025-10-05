extends Node2D

class_name Monster

static var TURN_TIME := 0.5

@onready var animation_player = $AnimationPlayer
@onready var sprite_scale = $AnimatedSprite2D.scale

func _init():
    if self.get_script() == Monster:
        push_error("Monster is an abstract class and should not be instantiated directly.")

func act_turn():
    @warning_ignore("REDUNDANT_AWAIT")
    await null
    push_error("act_turn() must be implemented by subclasses of Monster.")

@onready var block_body = $CharacterBody2D
@onready var attack_area = $Area2D

@export var health: int = 1
var current_health: int = health

func _ready():
    animation_player.play("hover")

func on_turn_end() -> void:
    block_body.process_mode = Node.PROCESS_MODE_INHERIT
    attack_area.process_mode = Node.PROCESS_MODE_DISABLED

func on_turn_start() -> void:
    block_body.process_mode = Node.PROCESS_MODE_DISABLED
    attack_area.process_mode = Node.PROCESS_MODE_INHERIT

func highlight() -> void:
    modulate = Color(1.0, 0.913, 0.623, 0.549) # ffe99f8c

func unhighlight() -> void:
    modulate = Color.WHITE

func take_damage(amount: int) -> void:
    current_health -= amount
    animation_player.play("take_damage")
    await animation_player.animation_finished
    if current_health <= 0:
        die()
    else:
        animation_player.play("hover")

func die():
    queue_free()

func face_direction(is_left) -> void:
    $AnimatedSprite2D.scale.x = abs(sprite_scale.x) * (-1 if is_left else 1)

func play_sound():
    Global.sfx_player.play_sfx(self)