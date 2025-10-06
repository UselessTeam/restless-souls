extends Monster

class_name DeathTuto

func act_turn():
    if Global.player.global_position.distance_to(global_position) > 400:
        return
    take_damage(1000)
