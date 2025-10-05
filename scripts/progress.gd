class_name Progress

var normal_ghosts: int = 0:
    set(value):
        if normal_ghosts != value:
            normal_ghosts = max(value, 0)
            on_change.emit()
var water_ghosts: int = 0:
    set(value):
        if water_ghosts != value:
            water_ghosts = max(value, 0)
            on_change.emit()
var fire_ghosts: int = 0:
    set(value):
        if fire_ghosts != value:
            fire_ghosts = max(value, 0)
            on_change.emit()
var thunder_ghosts: int = 0:
    set(value):
        if thunder_ghosts != value:
            thunder_ghosts = max(value, 0)
            on_change.emit()
var total_ghosts:
    get:
        return normal_ghosts + fire_ghosts + water_ghosts + thunder_ghosts

signal on_change()

func get_max_health() -> int:
    print("TODO: max health")
    return 5

func get_max_energy() -> float:
    print("TODO: max energy")
    return 5.0

func is_spell_unlocked(spell_key: String) -> bool:
    match spell_key:
        "whirlpool":
            return water_ghosts > 0
        "fireball":
            return fire_ghosts > 0
        "lightning":
            return thunder_ghosts > 0
    return true