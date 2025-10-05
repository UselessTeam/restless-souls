extends MarginContainer

class_name EnergyBar

const STEP_ENERGY_COST: float = 0.01
const DEAD_ZONE: float = 4.0
const MIN_ENERGY: float = -0.1

@onready var base_energy_bar: Bar = $Base
@onready var spell_energy_bar: Bar = $Spell
@onready var walk_energy_bar: Bar = $Walk
@onready var knots: Node = $Knots/List

var player_last_position: Vector2 = Vector2.ZERO

var max_energy: float = 0.9:
    set(value):
        if max_energy != value:
            max_energy = max(value, 1.0)
            update_knots_count()
            update_bars_and_knots()
var step_energy: float = max_energy:
    set(value):
        step_energy = value
        update_bars_and_knots()
var walk_energy_drain: float = 0.0:
    set(value):
        walk_energy_drain = value
        update_bars_and_knots()
var reserved_energy_for_spell: float = 0.0:
    set(value):
        reserved_energy_for_spell = value
        update_bars_and_knots()
var energy_before_spell: float:
    get:
        return step_energy - walk_energy_drain
var next_energy: float:
    get:
        return step_energy - walk_energy_drain - reserved_energy_for_spell

func update_knots_count():
    var target_knot_count = floori(max_energy) + 1
    while knots.get_child_count() < target_knot_count:
        var new_knot = knots.get_child(0).duplicate()
        new_knot.name = "Knot-%d" % (knots.get_child_count() - 1)
        knots.add_child(new_knot)
    for delete_index in range(target_knot_count, knots.get_child_count()):
        knots.get_child(delete_index).queue_free()
    
    for i in range(target_knot_count):
        var knot: Control = knots.get_child(i)
        knot.anchor_left = i / max_energy
        knot.anchor_right = i / max_energy

func update_bars_and_knots():
    base_energy_bar.fraction = next_energy / max_energy
    spell_energy_bar.fraction = energy_before_spell / max_energy
    walk_energy_bar.fraction = step_energy / max_energy

    for i in range(knots.get_child_count()):
        var knot: Control = knots.get_child(i)
        if i > step_energy:
            knot.hide()
            continue
        knot.show()
        if i < next_energy:
            knot.modulate = base_energy_bar.modulate
        elif i < energy_before_spell:
            knot.modulate = spell_energy_bar.modulate
        else:
            knot.modulate = walk_energy_bar.modulate


func start_battle():
    max_energy = Global.progress.get_max_energy()

func start_turn():
    step_energy = max_energy
    reserved_energy_for_spell = 0.0
    walk_energy_drain = 0.0

func start_step():
    player_last_position = Global.player.position
    step_energy = next_energy
    reserved_energy_for_spell = 0.0
    walk_energy_drain = 0.0

func _process(_delta: float):
    if not Global.is_battling():
        return
    walk_energy_drain = energy_cost_for_position(Global.player.position)
    

func energy_cost_for_position(_position: Vector2) -> float:
    var distance = max(0, player_last_position.distance_to(_position) - DEAD_ZONE)
    return distance * STEP_ENERGY_COST

func has_enough_energy(_position: Vector2) -> bool:
    if step_energy <= 0:
        return false
    return step_energy - energy_cost_for_position(_position) >= MIN_ENERGY

func project_to_reachable_position(_position: Vector2) -> Vector2:
    return _position.move_toward(player_last_position, (energy_cost_for_position(_position) - step_energy + MIN_ENERGY) / STEP_ENERGY_COST)
