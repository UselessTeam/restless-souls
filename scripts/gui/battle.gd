extends CanvasLayer

class_name Battle

var on: bool = false
@onready var spell_bar: SpellsBar = $Spells
@onready var energy: Energy = $Energy
var battle_area: BattleArea = null

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
    player_turn = true
    energy.start_step()
    spell_bar.player_turn_started()

var player_turn: bool = true

func _process(_delta: float):
    if not on or player_turn:
        return

    if Input.is_action_just_pressed("action_escape"):
        print("TODO")
