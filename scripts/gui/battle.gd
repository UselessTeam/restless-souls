extends CanvasLayer

class_name Battle

signal player_action_received(action)

var on: bool = false
@onready var spell_bar: SpellsBar = $Spells
@onready var energy: Energy = $Energy
var battle_area: BattleArea = null
var is_player_turn: bool = true
var is_launching_spell: bool = false

func _ready():
    visible = false
    Global.battle = self
    Global.battle_phase_start.connect(_on_battle_phase_start)
    Global.battle_phase_end.connect(_on_battle_phase_end)

func do_player_action():
    var spell = spell_bar.current_spell_action
    player_action_received.emit(spell)

func pass_player_turn():
    player_action_received.emit(null)

func rollout_battle(_battle_area: BattleArea):
    battle_area = _battle_area
    visible = true
    on = true
    energy.start_battle()
    while Global.player.health > 0 and battle_area.has_monsters():
        is_player_turn = true
        while is_player_turn:
            battle_area.show_player_base_position()
            energy.start_step()
            spell_bar.player_step_started()
            var action = await player_action_received
            Global.current_battle_area.hide_player_base_position()
            if not action:
                is_player_turn = false
                break
            await action.do()
            if not battle_area.has_monsters():
                break
        if not battle_area.has_monsters():
            break
        # Monster turn
        await battle_area.monsters_act()
    visible = false
    on = false
    var won = Global.player.health > 0
    if won:
        print("WON :D")
    else:
        print("lost :<")
    battle_area.close_battle()

func _on_battle_phase_start(_battle_area: BattleArea):
    rollout_battle(_battle_area)

func _on_battle_phase_end():
    visible = false
    on = false

func _process(_delta: float):
    if !Global.can_player_act():
        return

    if Input.is_action_just_pressed("action_escape"):
        print("TODO")

func _unhandled_input(event):
    if is_player_turn and event.is_action_pressed("monster_turn"):
        pass_player_turn()
