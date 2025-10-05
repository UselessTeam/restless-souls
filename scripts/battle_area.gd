extends Node2D

class_name BattleArea

var boundaries: StaticBody2D
var enter_zone: Area2D

@export var packed_monsters: Array[PackedScene]
@export var dialogs: Array[String] = []

var monsters: Array[Monster]

func _ready():
    boundaries = $Boundaries
    enter_zone = $EnterZone

    enter_zone.body_entered.connect(on_area_body_entered)

    reset_battle()

func on_area_body_entered(body):
    if body is Player:
        trigger_battle.call_deferred()

func trigger_battle():
    boundaries.process_mode = Node.PROCESS_MODE_ALWAYS
    enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
    if dialogs.size() > 1:
        @warning_ignore("INTEGER_DIVISION")
        for i in range(0, dialogs.size() / 2):
            await Global.dialog_box.display_text(dialogs[2 * i], dialogs[2 * i + 1], 2 * i + 2 < dialogs.size())
    Global.start_battle(self)

func close_battle():
    boundaries.process_mode = Node.PROCESS_MODE_DISABLED

func reset_battle():
    boundaries.process_mode = Node.PROCESS_MODE_DISABLED
    enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_PAUSABLE)
    reset_monsters()

func reset_monsters():
    var positions: Array = []
    if $Entities.get_child_count() > 0:
        for child in $Entities.get_children():
            if child is Monster:
                child.queue_free()
            if child is Marker2D:
                positions.append(child)
            else:
                for grandchild in child.get_children():
                    if grandchild is CollisionShape2D:
                        positions.append(grandchild)
                        break
    monsters.clear()
    var index = 0
    for packed_monster in packed_monsters:
        var monster: Monster = packed_monster.instantiate()
        var target
        if positions.size() > index:
            target = positions[index]
        else:
            target = $EnterZone/Shape
        if target is Marker2D:
            monster.position = target.position
        elif target is CollisionShape2D:
            var spawn_area: Rect2 = target.shape.get_rect()
            monster.position = Vector2(spawn_area.position.x + randf() * spawn_area.size.x, spawn_area.position.y + randf() * spawn_area.size.y)
        else:
            push_warning("Monster spawn target is not a valid type")
            monster.position = target.position
        $Entities.add_child(monster)
        monsters.append(monster)
        index += 1


func monsters_act():
    monsters.assign(monsters.filter(is_instance_valid))
    for monster in monsters:
        if monster:
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

func has_monsters() -> bool:
    return monsters.any(is_instance_valid)
