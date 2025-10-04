extends MarginContainer

class_name SpellsBar

var spells: Array[SpellButton]
var selected_spell: SpellButton = null
var current_spell_action: Spell = null

func _ready():
    spells.assign($Center/List.get_children().filter(func(child): return child is SpellButton))

func player_turn_started():
    select_spell(spells[0])

func reset_spell():
    select_spell(null)
    select_spell(spells[0])

func player_turn_ended():
    select_spell(null)

func select_spell(spell: SpellButton):
    if selected_spell == spell:
        return
    if current_spell_action:
        current_spell_action.queue_free()
    selected_spell = spell
    if spell:
        spell.grab_focus()
        current_spell_action = spell.packed_spell.instantiate()
        Global.world.add_child(current_spell_action)
