extends MarginContainer

class_name SpellsBar

var spells: Array[SpellButton]
var selected_spell: SpellButton = null
var current_spell_action: Spell = null

func _ready():
    spells.assign($Center/List.get_children().filter(func(child): return child is SpellButton))
    select_spell.call_deferred(spells[0])

func select_spell(spell: SpellButton):
    if selected_spell == spell:
        return
    if current_spell_action:
        current_spell_action.queue_free()
    if spell:
        spell.grab_focus()
        selected_spell = spell
        current_spell_action = spell.packed_spell.instantiate()
        Global.world.add_child(current_spell_action)