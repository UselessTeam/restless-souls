extends Node2D

class_name BattleArea

var boundaries: StaticBody2D
var enter_zone: Area2D

var monsters: Array[Monster]

func _ready():
    boundaries = $Boundaries
    enter_zone = $EnterZone

    enter_zone.body_entered.connect(on_area_body_entered)

    monsters.assign(get_children().filter(func(child): return child is Monster))

func on_area_body_entered(body):
    if body is Player:
        trigger_battle()

func trigger_battle():
    boundaries.process_mode = Node.PROCESS_MODE_ALWAYS
    enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
    Global.start_battle(self)
    Global.camera.reparent_smoothly(self)

func monsters_act():
    for monster in monsters:
        monster.act_turn()
    await get_tree().create_timer(Monster.turn_time).timeout


func _unhandled_input(event):
    if event.is_action_pressed("monster_turn"):
        monsters_act()