extends Node

enum GamePhase {LOADING, ROAM, BATTLE}

var world: World = null
var player: Player = null
var camera: Camera2DPlus = null
var phase: GamePhase = GamePhase.LOADING
var current_battle_area: BattleArea = null
var battle: Battle = null

signal battle_phase_start(battle_area: BattleArea)
signal battle_phase_end()
signal game_phase_change(previous: GamePhase, next: GamePhase)

func start_battle(battle_area):
    battle_phase_start.emit(battle_area)
    game_phase_change.emit(phase, GamePhase.BATTLE)
    phase = GamePhase.BATTLE
    current_battle_area = battle_area

func end_battle():
    battle_phase_end.emit()
    game_phase_change.emit(phase, GamePhase.ROAM)
    phase = GamePhase.ROAM

func is_battling() -> bool:
    return phase == GamePhase.BATTLE

func is_roaming() -> bool:
    return phase == GamePhase.ROAM
