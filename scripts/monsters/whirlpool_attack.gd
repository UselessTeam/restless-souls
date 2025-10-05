extends Node2D
class_name WhirlpoolAttack

const N_POINTS := 100

@onready var particles = $CPUParticles2D
@onready var animation_player = $AnimationPlayer

func _ready() -> void:
    var particle_points: Array[Vector2] = []
    for i in range(N_POINTS + 1):
        particle_points.append(Vector2(0, 100).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 95).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 90).rotated(i * TAU / N_POINTS))
        particle_points.append(Vector2(0, 85).rotated(i * TAU / N_POINTS))
    particles.emission_points = particle_points
    

func attack(ghost_position):
    animation_player.play("cast")
    create_tween() \
        .tween_property(Global.player, "global_position", \
                2 * ghost_position - Global.player.global_position, \
                animation_player.current_animation_length) \
        .set_trans(Tween.TRANS_QUAD) \
        .set_ease(Tween.EASE_IN_OUT)
    await animation_player.animation_finished
