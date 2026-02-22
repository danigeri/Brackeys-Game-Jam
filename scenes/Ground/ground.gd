extends Node2D

const GHOST_PLATFORM_FIX = preload("uid://bd36atmvg632q")
const PLATFORM_TEXTURE_ACT_1 = preload("uid://dbd0hcqx624e")
const PLATFORM_TEXTURE_ACT_2 = preload("uid://gy6tocvh8vx4")
const PLATFORM_TEXTURE_ACT_3 = preload("uid://8cqnj6cemc37")
const PLATFORM_TEXTURES_BY_ACT = [
	PLATFORM_TEXTURE_ACT_1, PLATFORM_TEXTURE_ACT_2, PLATFORM_TEXTURE_ACT_3
]

@onready var sprite_2d: Sprite2D = $StaticBody2D/Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]

	GameEvents.act_changed_to.connect(
		func(_act_num: int):
			sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]
	)

	# todo ghost
	GameEvents.ghost_mode_on.connect(
		func(ghost_mode: bool):
			if ghost_mode:
				sprite_2d.texture = GHOST_PLATFORM_FIX
			else:
				sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]
	)
