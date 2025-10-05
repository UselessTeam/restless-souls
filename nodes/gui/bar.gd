@tool
extends Container

class_name Bar

@export var fraction: float = 1.0:
    set(value):
        fraction = clamp(value, 0.0, 1.0)
        queue_sort()

@export var padding: float = 0.0
@export var y_margin: float = 0.0

func _notification(what):
    if what == NOTIFICATION_SORT_CHILDREN:
        _sort_children()

func _sort_children() -> void:
    var rect: Rect2 = get_rect()
    var width = (rect.size.x - 2 * padding) * fraction + 2 * padding
    for child in get_children():
        if is_instance_valid(child) and child is Control:
            fit_child_in_rect(child, Rect2(Vector2(0, y_margin), Vector2(width, rect.size.y - 2 * y_margin)))
