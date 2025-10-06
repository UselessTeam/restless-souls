extends ColorRect
class_name DialogBox

@onready var texture_rect = $TextureRect
@onready var label = $Label

@export var player: Texture2D
@export var grimmy: Texture2D
@export var burned: Texture2D
@export var drowned: Texture2D
@export var electrocuted: Texture2D
@export var knife: Texture2D
@export var sad: Texture2D

@export_file("*.txt") var start_text: String

const MIN_SHOW_TIME = 0.3
const FADE_IN_OUT_TIME = 0.1

var is_showing_text: bool
signal text_finished()
signal skip_text()

func _ready():
    modulate.a = 0
    Global.dialog_box = self
    await get_tree().create_timer(MIN_SHOW_TIME).timeout
    display_text(start_text)

func display_text(file_path):
    var text = FileAccess.open(file_path, FileAccess.READ) \
            .get_as_text().split("\n\n")
        
    @warning_ignore("INTEGER_DIVISION")
    for i in range(0, text.size()):
        var lines = text[i].split("\n")
        await display_lines(lines[0], lines.slice(1), i + 1 < text.size())
    

func display_lines(texture_name, text, leave_on = false):
    is_showing_text = true
    texture_rect.texture = get_texture(texture_name)
    label.text = "\n".join(text)
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
        "grimmy":
            return grimmy
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
