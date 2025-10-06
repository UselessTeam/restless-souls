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

var death_count: int = 0

signal on_change()

func get_max_health() -> int:
    var bonus = 0
    if death_count >= 3:
        bonus = 1
    if total_ghosts == 0:
        return 2 + bonus
    if total_ghosts <= 2:
        return 3 + bonus
    if total_ghosts <= 5:
        return 5 + bonus
    if total_ghosts <= 10:
        return 5 + bonus
    return 7 + bonus

func is_game_done():
    return total_ghosts >= 14

func get_max_energy() -> float:
    return 2.0 + 0.5 * sqrt(2.0 + min(total_ghosts, 6) + 0.5 * clamp(death_count - 1, 0, 10))

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