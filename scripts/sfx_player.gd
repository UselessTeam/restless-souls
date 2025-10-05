extends AudioStreamPlayer

class_name SfxPlayer

@export var slash: AudioStream
@export var fire: AudioStream
@export var water: AudioStream
@export var electric: AudioStream
@export var shoot: AudioStream


func _ready():
    Global.sfx_player = self

func play_sfx(thing):
    if thing is Spell:
        stream = get_audio(thing.sound)
        play()
    if thing is Monster:
        if thing.name == "Drowned":
            stream = water
        elif thing.name == "Electrocuted":
            stream = electric
        elif thing.name == "Burned":
            stream = fire
        elif thing.name == "KnifeGhost":
            stream = slash
        elif thing.name == "ShootGhost":
            stream = shoot
        play()

func get_audio(audio_name: String) -> AudioStream:
    match audio_name:
        "slash":
            return slash
        "fire":
            return fire
        "water":
            return water
        "electric":
            return electric
        _:
            push_warning("Unknown texture name: %s" % audio_name)
            return null
