extends AudioStreamPlayer

class_name MusicPlayer

@export var world_music: AudioStream
@export var battle_music: AudioStream

func _ready():
    play_world_music()
    Global.battle_phase_start.connect(play_battle_music)
    Global.battle_phase_end.connect(play_world_music)

func play_world_music():
    if stream != world_music:
        stream = world_music
        play()

func play_battle_music(_area = null):
    if stream != battle_music:
        stream = battle_music
        play()