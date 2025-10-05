extends Node

enum GamePhase {LOADING, ROAM, BATTLE}

var phase: GamePhase = GamePhase.LOADING
@onready var progress: Progress = Progress.new()

var world: World = null
var player: Player = null
var camera: Camera2DPlus = null
var battle: Battle = null
var dialog_box: DialogBox = null

var last_checkpoint: Vector2 = Vector2.ZERO:
    set(value):
        if value is Vector2:
            has_checkpoint = true
            last_checkpoint = value
        else:
            has_checkpoint = false
var has_checkpoint: bool = false

signal battle_phase_start(battle_area: BattleArea)
signal battle_phase_end()
signal game_phase_change(previous: GamePhase, next: GamePhase)

func start_battle(battle_area):
    game_phase_change.emit(phase, GamePhase.BATTLE)
    phase = GamePhase.BATTLE
    battle_phase_start.emit(battle_area)

func end_battle():
    battle_phase_end.emit()
    game_phase_change.emit(phase, GamePhase.ROAM)
    phase = GamePhase.ROAM

func is_battling() -> bool:
    return phase == GamePhase.BATTLE

func is_roaming() -> bool:
    return phase == GamePhase.ROAM

func can_player_act() -> bool:
    if dialog_box.is_showing_text:
        return false
    return is_roaming() or (is_battling() and battle.is_player_step)

func _process(_delta):
    if Input.is_action_just_pressed("cheat_unlock"):
        print("Cheat: Unlock all spells")
        progress.normal_ghosts += 1
        progress.water_ghosts += 1
        progress.fire_ghosts += 1
        progress.electric_ghosts += 1
