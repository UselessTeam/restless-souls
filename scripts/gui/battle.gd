extends CanvasLayer

var on: bool = false
# @onready var spell_bar: SpellBar = $SpellBar

func _ready():
    visible = false
    Global.battle_phase_start.connect(_on_battle_phase_start)
    Global.battle_phase_end.connect(_on_battle_phase_end)

func _on_battle_phase_start():
    visible = true
    on = true
    player_turn = true

func _on_battle_phase_end():
    visible = false
    on = false

var player_turn: bool = true

func _process(_delta: float):
    if not on or player_turn:
        return

    if Input.is_action_just_pressed("action_escape"):
        print("TODO")
