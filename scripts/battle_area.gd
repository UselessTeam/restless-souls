extends Node2D


var boundaries: StaticBody2D
var enter_zone: Area2D

func _ready():
	boundaries = $Boundaries
	enter_zone = $EnterZone

	enter_zone.body_entered.connect(on_area_body_entered)

func on_area_body_entered(body):
	if body is Player:
		trigger_battle()

func trigger_battle():
	boundaries.process_mode = Node.PROCESS_MODE_ALWAYS
	enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	Global.camera.reparent_smoothly(self)