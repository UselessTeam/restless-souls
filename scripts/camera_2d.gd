extends Camera2D

class_name Camera2DPlus

func _ready():
	Global.camera = self

func reparent_smoothly(new_parent: Node):
	var camera_position = global_position
	reparent(new_parent, true)
	global_position = camera_position

	var camera_tween = create_tween()
	camera_tween.tween_property(self, "position", Vector2(0, 0), 0.5)
