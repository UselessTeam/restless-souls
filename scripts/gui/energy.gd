extends MarginContainer

class_name Energy

@onready var bar: TextureProgressBar = $Bar
var player_last_position: Vector2 = Vector2.ZERO
var energy_last_value: float = 0.0

const MAX_ENERGY: float = 5.0
const STEP_ENERGY_COST: float = 0.01
const DEAD_ZONE: float = 4.0
const MIN_ENERGY: float = -0.1

func _ready():
    pass

func update_essence(value: float):
    bar.value = value

func start_battle():
    bar.max_value = MAX_ENERGY
    update_essence(MAX_ENERGY)

func start_step():
    player_last_position = Global.player.position
    energy_last_value = bar.value

func _process(_delta: float):
    if not Global.is_battling():
        return
    var energy_drain = energy_cost_for_position(Global.player.position)
    update_essence(energy_last_value - energy_drain)

func energy_cost_for_position(_position: Vector2) -> float:
    var distance = max(0, player_last_position.distance_to(_position) - DEAD_ZONE)
    return distance * STEP_ENERGY_COST

func has_enough_energy(_position: Vector2) -> bool:
    if energy_last_value <= 0:
        return false
    return energy_last_value - energy_cost_for_position(_position) >= MIN_ENERGY

func project_to_reachable_position(_position: Vector2) -> Vector2:
    return _position.move_toward(player_last_position, (energy_cost_for_position(_position) - energy_last_value + MIN_ENERGY) / STEP_ENERGY_COST)
