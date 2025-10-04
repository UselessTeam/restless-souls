extends Node2D

class_name Monster

static var turn_time := 0.5

func _init():
    if self.get_script() == Monster:
        push_error("Monster is an abstract class and should not be instantiated directly.")

func act_turn():
    await null
    push_error("act_turn() must be implemented by subclasses of Monster.")

@onready var block_body = $CharacterBody2D
@onready var attack_area = $Area2D

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

func damage() -> void:
    print("Monster took damage")

func face_direction(is_left) -> void:
    $Sprite2D.flip_h = is_left
