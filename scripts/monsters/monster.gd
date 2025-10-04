extends Node2D

class_name Monster

static var turn_time := 0.5

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
    if current_health <= 0:
        die()

func die():
    queue_free()

func face_direction(is_left) -> void:
    $Sprite2D.flip_h = is_left