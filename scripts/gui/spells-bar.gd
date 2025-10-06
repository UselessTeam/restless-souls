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
    if slash_spell.visible and not slash_spell.disabled and Global.battle.energy.has_enough_energy_for_spell(slash_spell.cost):
       select_spell(0)

func turn_ended():
    select_spell(-1)

func select_spell(spell_index: int):
    if not Global.can_player_act():
        return
    if selected_spell == spell_index:
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
    select_spell((selected_spell + i) % max_spells)
