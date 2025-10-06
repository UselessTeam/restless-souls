extends Camera2D

class_name Camera2DPlus

@onready var effects: Node = $Effects

signal action_pressed()

func _ready():
    Global.camera = self
func _process(_delta):
    if Input.is_action_pressed("action_use"):
        action_pressed.emit()

func reparent_smoothly(new_parent: Node):
    var camera_position = global_position
    reparent(new_parent, true)
    global_position = camera_position

    var camera_tween = create_tween()
    await camera_tween.tween_property(self, "position", Vector2(0, 0), 0.5).finished

func open_fail_screen():
    var black_screen = effects.get_node("BlackScreen") as ColorRect
    black_screen.modulate = Color(1, 1, 1, 0)
    black_screen.visible = true
    await create_tween() \
        .tween_property(black_screen, "modulate:a", 1.0, 0.5) \
        .finished

func close_fail_screen():
    var black_screen = effects.get_node("BlackScreen") as ColorRect
    await create_tween() \
        .tween_property(black_screen, "modulate:a", 0.0, 0.5) \
        .finished
    black_screen.visible = false

func open_finish_screen():
    $Title.text = "Congratulations, you have collected all the souls ravaging the town!\nThanks for playing our game ;)"
    await open_fail_screen()
    await action_pressed
    get_tree().quit()
