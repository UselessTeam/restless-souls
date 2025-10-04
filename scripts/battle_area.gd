extends Node2D

class_name BattleArea

var boundaries: StaticBody2D
var enter_zone: Area2D

var monsters: Array[Monster]

var is_monster_turn := false

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
    is_monster_turn = true
    for monster in monsters:
        monster.on_turn_start()
        monster.act_turn()
    await get_tree().create_timer(Monster.turn_time).timeout
    for monster in monsters:
        monster.on_turn_end()
    is_monster_turn = false

func _unhandled_input(event):
    if event.is_action_pressed("monster_turn"):
        monsters_act()

func show_player_base_position():
    var player_sprite_position = Global.player.animated_sprite.global_position
    var node = Global.player.player_sprite_prefab.instantiate()
    node.modulate = Color(1, 1, 1, 0.3)
    self.add_child(node)
    node.global_position = player_sprite_position

func hide_player_base_position():
    var player_sprite = get_node_or_null("PlayerSprite")
    if player_sprite:
        player_sprite.queue_free()
