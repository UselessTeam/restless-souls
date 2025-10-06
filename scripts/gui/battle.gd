extends CanvasLayer

class_name Battle

signal player_action_received(action)
signal step_started()
signal turn_ended()

var on: bool = false
@onready var spell_bar: SpellsBar = $Spells
@onready var health: HealthBar = $Bottom/List/Health
@onready var energy: EnergyBar = $Bottom/List/Energy
var battle_area: BattleArea = null
var is_player_turn: bool = false
var is_player_step: bool = false

func _init():
    Global.battle = self

func _ready():
    visible = false
    Global.battle_phase_start.connect(_on_battle_phase_start)
    Global.battle_phase_end.connect(_on_battle_phase_end)

func do_player_action() -> bool:
    var spell = spell_bar.current_spell_action
    if is_instance_valid(spell):
        Global.sfx_player.play_sfx(spell)
        player_action_received.emit(spell)
        return true
    else:
        pass_player_turn()
        return false

func pass_player_turn():
    player_action_received.emit(null)

func rollout_battle(_battle_area: BattleArea):
    battle_area = _battle_area
    is_player_turn = false
    await Global.camera.reparent_smoothly(battle_area)
    visible = true
    on = true
    health.start_battle()
    energy.start_battle()
    while health.health > 0 and battle_area.has_monsters():
        is_player_turn = true
        energy.start_turn()
        while is_player_turn:
            battle_area.show_player_base_position()
            energy.start_step()
            step_started.emit()
            is_player_step = true
            spell_bar.player_step_started()
            var action = await player_action_received
            is_player_step = false
            battle_area.hide_player_base_position()
            if not action:
                is_player_turn = false
                spell_bar.turn_ended()
                break
            await action.do()
            if not battle_area.has_monsters():
                break
        turn_ended.emit()
        if not battle_area.has_monsters():
            break
        # Monster turn
        await battle_area.monsters_act()
        if not battle_area.has_monsters():
            break
        await get_tree().create_timer(0.1).timeout
    spell_bar.turn_ended()
    visible = false
    on = false
    var won = health.health > 0
    if won:
        battle_area.close_battle(true)
        Global.end_battle()
        await Global.camera.reparent_smoothly(Global.player)
        Global.player.check_end_game()
    else:
        battle_area.close_battle(false)
        Global.end_battle()
        Global.player.visible = false
        await Global.camera.open_fail_screen()
        await something_pressed
        Global.player.position = Global.last_checkpoint
        await get_tree().create_timer(0.05).timeout
        Global.camera.reparent_smoothly(Global.player)
        battle_area.reset_battle()
        await get_tree().create_timer(0.25).timeout
        await Global.camera.close_fail_screen()
        Global.player.visible = true

func _on_battle_phase_start(_battle_area: BattleArea):
    rollout_battle(_battle_area)

func _on_battle_phase_end():
    visible = false
    on = false

signal something_pressed()

func _process(_delta: float):
    if Input.is_action_just_pressed("action_use") or Input.is_action_just_pressed("action_escape"):
        something_pressed.emit()

    if Global.is_battling() and !Global.can_player_act():
        return

    if Input.is_action_just_pressed("action_escape"):
        Global.player.position = energy.player_last_position


func _unhandled_input(event):
    if is_player_step and event.is_action_pressed("monster_turn"):
        pass_player_turn()
