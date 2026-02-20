extends Node

enum Sound {
	CLICK,
	PLATFORM_MOVE,
	STAR_PICKUP,
	FALL_IMPACT,
	FALL_REACTION,
	SPOTLIGHT,
	CURTAIN,
	CHEER_ACT_FINISH,
	CHEER_GAME_FINISH,
	SET_MOVE
}

@export var click_sound: AudioStream
@export var platform_move_sound: AudioStream
@export var star_pickup_cheer_sound: AudioStream
@export var fall_impact_sound: AudioStream
@export var fall_first_reaction_sound: AudioStream
@export var spotlight_sound: AudioStream
@export var curtain_sound: AudioStream
@export var cheer_act_finish_sound: AudioStream
@export var cheer_game_finish_sound: AudioStream
@export var set_move_sound: AudioStream
@export var crowd_sounds: Array[AudioStream]

var sound_library: Dictionary
var active_sounds = {}


func _ready() -> void:
	sound_library.set(Sound.CLICK, click_sound)
	sound_library.set(Sound.PLATFORM_MOVE, platform_move_sound)
	sound_library.set(Sound.STAR_PICKUP, star_pickup_cheer_sound)
	sound_library.set(Sound.FALL_IMPACT, fall_impact_sound)
	sound_library.set(Sound.FALL_REACTION, fall_first_reaction_sound)
	sound_library.set(Sound.SPOTLIGHT, spotlight_sound)
	sound_library.set(Sound.CURTAIN, curtain_sound)
	sound_library.set(Sound.CHEER_ACT_FINISH, cheer_act_finish_sound)
	sound_library.set(Sound.CHEER_GAME_FINISH, cheer_game_finish_sound)
	sound_library.set(Sound.SET_MOVE, set_move_sound)


func play_sound_by_id(id: Sound, bus: String = "SFX"):
	var stream = sound_library.get(id)
	return play_sfx(stream, bus)


func play_sfx(stream: AudioStream, bus: String) -> AudioStreamPlayer:
	if active_sounds.has(stream) and active_sounds[stream].is_playing():
		return active_sounds[stream]

	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	
	new_player.bus = bus
	new_player.stream = stream
	new_player.play()
	
	active_sounds[stream] = new_player
	
	new_player.finished.connect(func():
		active_sounds.erase(stream)
		new_player.queue_free()
	)
	
	return new_player


func play_random_crowd_sound() -> AudioStreamPlayer:
	return play_sfx(crowd_sounds.pick_random(), "SFX")
