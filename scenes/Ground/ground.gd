extends Node2D


@onready var sprite_2d: Sprite2D = $StaticBody2D/Sprite2D

var platform_texture_act_1 = preload("uid://d1e1qheab4ty0")
var platform_texture_act_2 = preload("uid://bd1lxcriffsb6")
var platform_texture_act_3 = preload("uid://bnaalokfffe01")


var platform_textures_by_act = [
	platform_texture_act_1,
	platform_texture_act_2,
	platform_texture_act_3
]
const GHOST_PLATFORM_FIX = preload("uid://w38ebu3tible")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = platform_textures_by_act[GameEvents.current_act - 1]
	
	GameEvents.act_changed_to.connect(func(act_num: int):
		sprite_2d.texture = platform_textures_by_act[GameEvents.current_act - 1]
	)
	
	# todo ghost
	GameEvents.ghost_mode_on.connect(func(ghost_mode: bool):
		if ghost_mode:
			sprite_2d.texture = GHOST_PLATFORM_FIX
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
