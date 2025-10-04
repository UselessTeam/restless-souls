extends MarginContainer

@onready var bar: TextureProgressBar = $Bar

func _ready():
    pass

func update_essence(value: float):
    bar.value = value
