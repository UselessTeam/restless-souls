extends CanvasLayer

func _ready():
    visible = false
    Global.battle_phase_start.connect(_on_battle_phase_start)
    Global.battle_phase_end.connect(_on_battle_phase_end)

func _on_battle_phase_start():
    visible = true

func _on_battle_phase_end():
    visible = false