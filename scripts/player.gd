extends CharacterBody2D

class_name Player

# Movement speed in pixels per second
@export var speed := 200

func _ready():
	Global.player = self
	print("Connected controllers: ", Input.get_connected_joypads())

func _process(_delta):
	var direction := get_input_direction()

	velocity = direction * speed
	move_and_slide()

func get_input_direction() -> Vector2:
	# Gamepad stick input (left stick, usually index 0)
	var stick_input := Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	# Deadzone to avoid drift
	var deadzone := 0.2
	if stick_input.length() > deadzone:
		return stick_input.normalized()

	var direction := Vector2.ZERO

	# Keyboard input
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	return direction.normalized()
