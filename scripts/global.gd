extends Node

enum GamePhase {LOADING, ROAM, BATTLE}

var player: Player = null
var camera: Camera2DPlus = null
var phase: GamePhase = GamePhase.LOADING

signal battle_phase_start()
signal battle_phase_end()
signal game_phase_change(previous: GamePhase, next: GamePhase)

func start_battle():
    battle_phase_start.emit()
    game_phase_change.emit(phase, GamePhase.BATTLE)
    phase = GamePhase.BATTLE

func end_battle():
    battle_phase_end.emit()
    game_phase_change.emit(phase, GamePhase.ROAM)
    phase = GamePhase.ROAM

func is_battling() -> bool:
    return phase == GamePhase.BATTLE

func is_roaming() -> bool:
    return phase == GamePhase.ROAM
