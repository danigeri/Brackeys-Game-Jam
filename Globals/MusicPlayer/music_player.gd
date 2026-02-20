extends Node

@onready var audio_stream_player = $AudioStreamPlayer
const LEVEL_1_ITALY_STRANGE_PLACES = preload("uid://dy2kkjda4shcy")
const LEVEL_2_HELL_STRANGE_PLACES = preload("uid://cwmaku2j11fh1")
const LEVEL_3_HEAVEN_STRANGE_PLACES = preload("uid://cwatqnxxrxdm5")
const MAIN_MENU_MUSIC = preload("uid://db7uvmkwgnlto")


func start_music() -> void:
	audio_stream_player.stream = MAIN_MENU_MUSIC
	audio_stream_player.play()

##act change signallal és egy swtich-ben jobb lenne de így bután is működik
##ha az act-ek ready-jében meghívjuk
func play_act_1() -> void:
	audio_stream_player.stream = LEVEL_1_ITALY_STRANGE_PLACES
	audio_stream_player.play()
	
func play_act_2() -> void:
	audio_stream_player.stream = LEVEL_2_HELL_STRANGE_PLACES
	audio_stream_player.play()
	
func play_act_3() -> void:
	audio_stream_player.stream = LEVEL_3_HEAVEN_STRANGE_PLACES
	audio_stream_player.play()
