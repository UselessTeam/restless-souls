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

func close_battle():
    boundaries.process_mode = Node.PROCESS_MODE_DISABLED
    enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_ALWAYS)
    Global.end_battle()
    Global.camera.reparent_smoothly(Global.player)

func monsters_act():
    for monster in monsters:
        monster.on_turn_start()
        await monster.act_turn()
        monster.on_turn_end()
    return

var player_position_sprite: Node2D = null

func show_player_base_position():
    var player_sprite_position = Global.player.animated_sprite.global_position
    player_position_sprite = Global.player.player_sprite_prefab.instantiate()
    player_position_sprite.modulate = Color(1, 1, 1, 0.3)
    self.add_child(player_position_sprite)
    player_position_sprite.global_position = player_sprite_position

func hide_player_base_position():
    if player_position_sprite:
        player_position_sprite.queue_free()
        player_position_sprite = null
