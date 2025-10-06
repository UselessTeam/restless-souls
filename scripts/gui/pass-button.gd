extends Button

@onready var spells_node = get_node("../../..") as SpellsBar

func _pressed():
    spells_node.select_spell(-1)
