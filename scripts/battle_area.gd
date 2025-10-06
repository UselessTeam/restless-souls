extends Node2D

class_name BattleArea

var boundaries: StaticBody2D
var enter_zone: Area2D

@export var packed_monsters: Array[PackedScene]
@export_file("*.txt") var starting_dialog_file: String = ""
@export_file("*.txt") var won_dialog_file: String = ""
@export_file("*.txt") var lost_dialog_file: String = ""
@export var rewards: Dictionary

var monsters: Array[Monster]

func _ready():
    boundaries = $Boundaries
    enter_zone = $EnterZone

    enter_zone.body_entered.connect(on_area_body_entered)

    reset_battle()
    auto_get_rewards()

func on_area_body_entered(body):
    if body is Player:
        trigger_battle.call_deferred()

func maybe_dialog(file):
    if file.length() > 0:
        await Global.file.display_text(starting_dialog_file)


func trigger_battle():
    boundaries.process_mode = Node.PROCESS_MODE_ALWAYS
    enter_zone.set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
    maybe_dialog(starting_dialog_file)
    Global.start_battle(self)

func close_battle(won: bool):
    boundaries.process_mode = Node.PROCESS_MODE_DISABLED
    if won:
        maybe_dialog(won_dialog_file)
        give_rewards()
        print("TODO: Rewards")
    else:
        maybe_dialog(lost_dialog_file)

func auto_get_rewards():
    for monster in monsters:
        if monster is Monster:
            var key = monster.type + "_ghosts"
            rewards[key] = rewards.get_or_add(key, 0) + 1


func give_rewards():
    for key in rewards:
        var value = rewards[key]
        if Global.progress.get(key) == null:
            push_warning("Unknown key: `" + str(key) + "`")
        else:
            Global.progress.set(key, Global.progress.get(key) + value)

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
            monster.position = Vector2(target.position.x + spawn_area.position.x + randf() * spawn_area.size.x, target.position.y + spawn_area.position.y + randf() * spawn_area.size.y)
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
