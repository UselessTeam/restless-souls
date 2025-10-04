extends MarginContainer

class_name SpellsBar

var spells: Array[SpellButton]
var selected_spell: SpellButton = null

func _ready():
    spells.assign($Center/List.get_children().filter(func(child): return child is SpellButton))
    selected_spell = spells[0]

func select_spell(spell: SpellButton):
    spell.grab_focus()
    selected_spell = spell
