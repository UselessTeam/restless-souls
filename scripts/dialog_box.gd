extends ColorRect
class_name DialogBox

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var player: Texture2D
@export var burned: Texture2D
@export var drowned: Texture2D
@export var electrocuted: Texture2D
@export var knife: Texture2D
@export var sad: Texture2D

const MIN_SHOW_TIME = 0.3
const FADE_IN_OUT_TIME = 0.1

var is_showing_text: bool
signal text_finished()
signal skip_text()

func _ready():
    modulate.a = 0
    Global.dialog_box = self
    await get_tree().create_timer(MIN_SHOW_TIME).timeout
    display_text("player", "I heard some restless spirits are wreaking havoc around this town.\nTime to collect some souls.")

func display_text(texture_name, text, leave_on = false):
    is_showing_text = true
    texture_rect.texture = get_texture(texture_name)
    label.text = text
    print("displaying")
    await create_tween().tween_property(self, "modulate:a", 1, FADE_IN_OUT_TIME).finished
    await get_tree().create_timer(MIN_SHOW_TIME).timeout
    await skip_text
    if !leave_on:
        await create_tween().tween_property(self, "modulate:a", 0, FADE_IN_OUT_TIME).finished
    text_finished.emit()
    is_showing_text = false

func get_texture(texture_name: String) -> Texture2D:
    match texture_name:
        "player":
            return player
        "burned":
            return burned
        "drowned":
            return drowned
        "electrocuted":
            return electrocuted
        "knife":
            return knife
        "sad":
            return sad
        _:
            push_warning("Unknown texture name: %s" % texture_name)
            return null

func _input(event: InputEvent) -> void:
    if event.is_action_pressed("action_use"):
        skip_text.emit()
