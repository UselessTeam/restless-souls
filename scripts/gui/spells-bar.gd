extends MarginContainer

class_name SpellsBar

var spells: Array[SpellButton]
var selected_spell: int
var max_spells: int = 4
var current_spell_action: Spell = null

func _ready():
    spells.assign($Center/List.get_children().filter(func(child): return child is SpellButton))

func player_step_started():
    select_spell(-1)
    select_spell(0)

func turn_ended():
    select_spell(-1)

func select_spell(spell_index: int):
    if selected_spell == spell_index:
        return
    if current_spell_action:
        current_spell_action.queue_free()
    if not Global.can_player_act():
        selected_spell = -1
        return
    selected_spell = spell_index
    if selected_spell >= 0:
        var spell = spells[selected_spell]
        spell.grab_focus()
        current_spell_action = spell.packed_spell.instantiate()
        Global.world.add_child(current_spell_action)

func toggle_spell(i: int):
    select_spell((selected_spell + i) % max_spells)
