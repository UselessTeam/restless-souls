extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200

@onready var animated_sprite = $AnimatedSprite2D

func _ready():
    Global.player = self
    animated_sprite.animation_finished.connect(_on_attack_animation_finished)

func _process(_delta):
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction * speed
    move_and_slide()


func _unhandled_input(event):
    if event.is_action_pressed("ui_accept"):
        animated_sprite.play("attack")

func _on_attack_animation_finished():
    if (animated_sprite.animation == "attack"):
        animated_sprite.play("idle")
