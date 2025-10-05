extends MarginContainer

@export_enum("normal", "fire", "electric", "water") var key: String = "normal"
@export var some_texture: Texture2D
@export var none_texture: Texture2D

@onready var label: Label = $Info/Label
@onready var icon: TextureRect = $Info/Icon

func _ready():
    Global.progress.on_change.connect(_change)
    _change()

func _change():
    var count: int = Global.progress.get(key + "_ghosts")
    if count == 0:
        icon.texture = none_texture
        label.hide()
        return
    icon.texture = some_texture
    if count == 1:
        label.hide()
    else:
        label.text = str(count)
        label.show()
