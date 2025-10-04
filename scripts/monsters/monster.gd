extends Node2D

class_name Monster

static var turn_time := 2.0

func _init():
    if self.get_script() == Monster:
        push_error("Monster is an abstract class and should not be instantiated directly.")

func act_turn() -> void:
    push_error("act_turn() must be implemented by subclasses of Monster.")