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
var electric_ghosts: int = 0:
    set(value):
        if electric_ghosts != value:
            electric_ghosts = max(value, 0)
            on_change.emit()
var total_ghosts:
    get:
        return normal_ghosts + fire_ghosts + water_ghosts + electric_ghosts

signal on_change()

func get_max_health() -> int:
    print("TODO: max health")
    return 5

func get_max_energy() -> float:
    print("TODO: max energy")
    return 5.0

func is_spell_unlocked(spell_key: String) -> bool:
    match spell_key:
        "slash":
            return normal_ghosts > 0
        "whirlpool":
            return water_ghosts > 0
        "fireball":
            return fire_ghosts > 0
        "lightning":
            return electric_ghosts > 0
    return true