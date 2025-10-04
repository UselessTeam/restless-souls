extends CanvasLayer

class_name Battle

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

func _on_battle_phase_start(_battle_area: BattleArea):
    battle_area = _battle_area
    visible = true
    on = true
    energy.start_battle()
    start_player_turn.call_deferred()

func _on_battle_phase_end():
    visible = false
    on = false

func start_player_turn():
    is_player_turn = true
    start_player_step.call_deferred()

func start_player_step():
    battle_area.show_player_base_position()
    energy.start_step()
    spell_bar.player_step_started()

func stop_player_step():
    battle_area.hide_player_base_position()
    spell_bar.player_step_ended()

func start_monster_turn():
    is_player_turn = false
    Global.current_battle_area.hide_player_base_position()
    await battle_area.monsters_act()
    start_player_turn()

func _process(_delta: float):
    if !Global.can_player_act():
        return

    if Input.is_action_just_pressed("action_escape"):
        print("TODO")

func _unhandled_input(event):
    if is_player_turn and event.is_action_pressed("monster_turn"):
        start_monster_turn()