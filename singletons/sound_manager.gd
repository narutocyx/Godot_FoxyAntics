extends Node

const SOUND_JUMP = "jump"
const SOUND_DAMAGE = "damage"
const SOUND_LANDDING = "landding"
const SOUND_LASER = "laser"

var SOUNDS: Dictionary = {
	SOUND_LANDDING: preload("res://assets/sound/land.wav"),
	SOUND_DAMAGE: preload("res://assets/sound/damage.wav"),
	SOUND_JUMP: preload("res://assets/sound/jump.wav"),
	SOUND_LASER: preload("res://assets/sound/laser.wav")
}

func play_clip(player: AudioStreamPlayer2D, clip_key: String) -> void:
	if SOUNDS.has(clip_key) == false:
		return
	player.stream = SOUNDS[clip_key]
	player.play()
