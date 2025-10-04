extends Node2D

class_name Monster

static var turn_time := 0.5

func _init():
    if self.get_script() == Monster:
        push_error("Monster is an abstract class and should not be instantiated directly.")

func act_turn() -> void:
    push_error("act_turn() must be implemented by subclasses of Monster.")

@onready var block_body = $CharacterBody2D
@onready var attack_area = $Area2D

func on_turn_end() -> void:
    block_body.process_mode = Node.PROCESS_MODE_INHERIT
    attack_area.process_mode = Node.PROCESS_MODE_DISABLED

func on_turn_start() -> void:
    block_body.process_mode = Node.PROCESS_MODE_DISABLED
    attack_area.process_mode = Node.PROCESS_MODE_INHERIT
