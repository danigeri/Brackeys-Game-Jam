extends Node2D

const GHOST_PLATFORM_FIX = preload("uid://bd36atmvg632q")
const PLATFORM_TEXTURE_ACT_1 = preload("uid://dbd0hcqx624e")
const PLATFORM_TEXTURE_ACT_2 = preload("uid://gy6tocvh8vx4")
const PLATFORM_TEXTURE_ACT_3 = preload("uid://8cqnj6cemc37")
const PLATFORM_TEXTURES_BY_ACT = [
	PLATFORM_TEXTURE_ACT_1, PLATFORM_TEXTURE_ACT_2, PLATFORM_TEXTURE_ACT_3
]

@onready var sprite_2d: Sprite2D = $StaticBody2D/Sprite2D

@onready var act_1: Sprite2D = $StaticBody2D/act1
@onready var act_2: Sprite2D = $StaticBody2D/act2
@onready var act_3: Sprite2D = $StaticBody2D/act3
@onready var ghost: Sprite2D = $StaticBody2D/ghost


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]
	show_correspondig_platforms()

	GameEvents.act_changed_to.connect(
		func(_act_num: int): show_correspondig_platforms()
		#sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]
	)

	# todo ghost
	GameEvents.ghost_mode_on.connect(
		func(ghost_mode: bool): show_correspondig_platforms()
		#if ghost_mode:
		#	sprite_2d.texture = GHOST_PLATFORM_FIX
		#else:
		#	sprite_2d.texture = PLATFORM_TEXTURES_BY_ACT[GameEvents.current_act - 1]
	)


func show_correspondig_platforms() -> void:
	if GameEvents.ghost_mode:
		print("GHOST")
		act_1.hide()
		act_2.hide()
		act_3.hide()
		ghost.show()
	else:
		ghost.hide()
		if GameEvents.current_act == 1:
			print("ACT1")
			act_1.show()
			act_2.hide()
			act_3.hide()
		elif GameEvents.current_act == 2:
			print("ACT2")
			act_1.hide()
			act_2.show()
			act_3.hide()
		elif GameEvents.current_act == 3:
			print("ACT3")
			act_1.hide()
			act_2.hide()
			act_3.show()
