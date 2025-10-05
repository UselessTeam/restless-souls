extends Button

class_name SpellButton

@export var number: int
@export var key: String
@export var packed_spell: PackedScene
@onready var spells_node = get_node("../../..") as SpellsBar

func _ready():
    Global.progress.on_change.connect(_check)
    _check()

func _check():
    visible = Global.progress.is_spell_unlocked(key)

func _pressed():
    spells_node.select_spell(self)
