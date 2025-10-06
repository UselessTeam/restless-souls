extends MarginContainer

class_name SpellsBar

var spells: Array[SpellButton]
var slash_spell: SpellButton:
    get:
        return spells[0]
@onready var pass_button: Button = $Center/List.get_children()[-1]
var selected_spell: int
var max_spells: int = 4
var current_spell_action: Spell = null

func _ready():
    spells.assign($Center/List.get_children().filter(func(child): return child is SpellButton))

func player_step_started():
    select_spell(-1)
    if Global.progress.is_spell_unlocked("slash") and Global.battle.energy.has_enough_energy_for_spell(slash_spell.cost):
        select_spell(0, true)
        slash_spell.button_pressed = true
    else:
        pass_button.button_pressed = true

func turn_ended():
    select_spell(-1)

func select_spell(spell_index: int, force: bool = false):
    if not force and not Global.can_player_act():
        return
    if current_spell_action:
        current_spell_action.queue_free()
    selected_spell = spell_index
    if selected_spell >= 0:
        var spell = spells[selected_spell]
        spell.button_pressed = true
        Global.battle.energy.reserved_energy_for_spell = spell.cost
        current_spell_action = spell.packed_spell.instantiate()
        current_spell_action.button = spell
        Global.world.add_child(current_spell_action)
    else:
        pass_button.button_pressed = true
        Global.battle.energy.reserved_energy_for_spell = 0

func toggle_spell(i: int):
    var new_spell_index = selected_spell
    var valid = false
    while not valid:
        new_spell_index = (new_spell_index + i) % (max_spells + 1)
        if new_spell_index == max_spells or new_spell_index == -1:
            new_spell_index = -1
            valid = true
        else:
            var new_spell: SpellButton = spells[new_spell_index]
            valid = Global.progress.is_spell_unlocked(new_spell.key)
    select_spell(new_spell_index)
