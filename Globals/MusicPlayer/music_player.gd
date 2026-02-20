extends Node

const LEVEL_1_ITALY_STRANGE_PLACES = preload("uid://dy2kkjda4shcy")
const LEVEL_2_HELL_STRANGE_PLACES = preload("uid://cwmaku2j11fh1")
const LEVEL_3_HEAVEN_STRANGE_PLACES = preload("uid://cwatqnxxrxdm5")
const MAIN_MENU_MUSIC = preload("uid://db7uvmkwgnlto")
const SILENCE_DB = -80.0
const NORMAL_DB = 0.0

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func start_music() -> void:
	audio_stream_player.stream = MAIN_MENU_MUSIC
	audio_stream_player.play()


##act change signallal és egy swtich-ben jobb lenne de így bután is működik
##ha az act-ek ready-jében meghívjuk
func play_act(act: int) -> void:
	audio_stream_player.volume_db = NORMAL_DB

	match act:
		1:
			audio_stream_player.stream = LEVEL_1_ITALY_STRANGE_PLACES
		2:
			audio_stream_player.stream = LEVEL_2_HELL_STRANGE_PLACES
		3:
			audio_stream_player.stream = LEVEL_3_HEAVEN_STRANGE_PLACES
	audio_stream_player.play()


func fade_in_music() -> void:
	audio_stream_player.volume_db = SILENCE_DB
	audio_stream_player.play()

	var tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", NORMAL_DB, 2.0)


func fade_out_music(duration: float = 2.0) -> AudioStreamPlayer:
	var tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", SILENCE_DB, duration)
	tween.finished.connect(audio_stream_player.stop)

	return audio_stream_player
