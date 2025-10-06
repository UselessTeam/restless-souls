extends Button

class_name SpellButton

@export var number: int
@export var key: String
@export var packed_spell: PackedScene
@export var cost: float
@export var cooldown: int = 0
@onready var spells_node = get_node("../../..") as SpellsBar

func _ready():
    Global.progress.on_change.connect(_check)
    Global.battle.step_started.connect(_on_or_off)
    Global.battle.turn_ended.connect(_off)
    _check()

func _check():
    visible = Global.progress.is_spell_unlocked(key)

func _on_or_off():
    disabled = !Global.battle.energy.has_enough_energy_for_spell(cost)

func _off():
    disabled = true

func _pressed():
    spells_node.select_spell(get_index())
