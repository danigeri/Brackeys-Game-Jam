extends Node2D

#player trail
const RECORD_INTERVAL := 0.05  # 1 second
const PATH_DOT_SCENE = preload("uid://co43cv8qwqnmv")
const MAIN_MENU: PackedScene = preload("uid://c64idl1pun738")

#acts
const ACT_1 = preload("uid://dc6mlfql3moyl")
const ACT_2 = preload("uid://dkqrhp8obyxw4")
const ACT_3 = preload("uid://k2t6pk66rnl3")

const REGULAR_GRADIENT_TEXTURE = preload("res://gradient_texture_regular.tres")
const GHOST_GRADIENT_TEXTURE = preload("res://gradient_texture_ghost.tres")

@export var crowd_reaction_timeout = 30.0
@export var energy_regular_run = 0.61
@export var energy_ghost_run = 1.3

var positions = []
var record_timer: float = 0.0

#stars
var required_total: int = 0
var optional_total: int = 0
var required_collected: int = 0
var optional_collected: int = 0

#camera
@onready var ghost_camera: Camera2D = $GhostCamera
@onready var player_camera: Camera2D = $Player/Camera2D

@onready var player: CharacterBody2D = $Player
#use this if line will be Line2d not Sprites
#@onready var line_2d: Line2D = $Line2D
@onready var path_dot_container: Node2D = $PathDotContainer

@onready var curtain_effect: Sprite2D = $CurtainEffect
@onready var act_container: Node2D = $ActContainer

@onready var point_light_2d: PointLight2D = $Player/PointLight2D


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	#signals
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	GameEvents.easy_mode_on.connect(handle_easy_mode)
	GameEvents.act_changed_to.connect(change_act)
	GameEvents.change_act_to(1)

	start_crowd_timer()

	point_light_2d.texture = REGULAR_GRADIENT_TEXTURE
	point_light_2d.energy = energy_regular_run


func _process(delta: float) -> void:
	if !GameEvents.ghost_mode:
		record_timer += delta
		if record_timer >= RECORD_INTERVAL:
			record_timer -= RECORD_INTERVAL
			positions.append(player.global_position)


func change_act(act: int):
	#print("change act", act)
	for child in act_container.get_children():
		child.queue_free()
	var act_scene = null
	var player_starting_position = Vector2.ZERO
	match act:
		1:
			act_scene = ACT_1.instantiate()
			player_starting_position = Vector2(-795, 145)
			player_camera.limit_right = 2750
			ghost_camera.limit_right = 2750
		2:
			act_scene = ACT_2.instantiate()
			player_starting_position = Vector2(-790, -420)
			player_camera.limit_right = 2750
			ghost_camera.limit_right = 2750
		3:
			act_scene = ACT_3.instantiate()
			player_starting_position = Vector2(-790, -420)
			player_camera.limit_right = 2100
			ghost_camera.limit_right = 2100

	act_container.add_child(act_scene)
	player.update_starting_position(player_starting_position)
	call_deferred("count_stars_palced_on_map")
	curtain_in_and_out(act)


func curtain_in_and_out(act: int) -> void:
	player_camera.zoom = Vector2(1.0, 1.0)
	point_light_2d.visible = false

	curtain_effect.visible = true
	curtain_effect.set_act_number(act)

	await get_tree().create_timer(0.8).timeout
	await SoundManager.play_sound_by_id(SoundManager.Sound.CURTAIN).finished
	curtain_effect.visible = false

	await get_tree().create_timer(0.3).timeout
	point_light_2d.visible = true
	await SoundManager.play_sound_by_id(SoundManager.Sound.SPOTLIGHT).finished

	var tween = create_tween()
	tween.tween_property(player_camera, "zoom", Vector2(1.6, 1.6), 0.5)


func handle_ghost_mode(is_ghost_mode):
	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)
	reset_stars()
	handle_player_path(is_ghost_mode)
	if is_ghost_mode:
		point_light_2d.texture = GHOST_GRADIENT_TEXTURE
		point_light_2d.energy = energy_ghost_run
	else:
		point_light_2d.texture = REGULAR_GRADIENT_TEXTURE
		point_light_2d.energy = energy_regular_run


func reset_stars() -> void:
	required_collected = 0
	optional_collected = 0
	#print("RESET")
	for star in get_tree().get_nodes_in_group("stars" + str(GameEvents.current_act)):
		star.reset_star()

	#print("ready, required_total: ", required_total)
	#print("ready, optional_total: ", optional_total)


func use_ghost_camera(is_ghost_mode) -> void:
	if is_ghost_mode:
		ghost_camera.make_current()


func handle_player_path(is_ghost_mode) -> void:
	if !is_ghost_mode:
		positions = []
		GameEvents.death_counter = 0
		clear_line_positions()
	if GameEvents.easy_mode || GameEvents.death_counter > 2:
		clear_line_positions()
		draw_player_path()


func clear_line_positions() -> void:
	for child in path_dot_container.get_children():
		child.queue_free()
	#use this if line will be Line2d not Sprites
	#line_2d.clear_points()


func draw_player_path() -> void:
	clear_line_positions()
	for pos in positions:
		var dot := PATH_DOT_SCENE.instantiate()
		dot.position = pos
		path_dot_container.add_child(dot)


#use this if line will be Line2d not Sprites
#func draw_player_path() -> void:
#print(positions)
#for pos in positions:
#line_2d.add_point(pos)


func show_hide_cursor(is_ghost_mode):
	if is_ghost_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func count_stars_palced_on_map():
	required_total = 0
	optional_total = 0
	#print(get_tree().get_nodes_in_group("stars" + str(GameEvents.current_act)))
	#print(str(GameEvents.current_act))
	for star in get_tree().get_nodes_in_group("stars" + str(GameEvents.current_act)):
		star.collected.connect(_on_star_collected)
		if star.star_type == star.StarType.REQUIRED:
			required_total += 1
		elif star.star_type == star.StarType.OPTIONAL:
			optional_total += 1
	#print("ready, required_total: ", required_total)
	#print("ready, optional_total: ", optional_total)


func start_crowd_timer() -> void:
	var random_crowd_noise_timer := Timer.new()

	random_crowd_noise_timer.autostart = true
	random_crowd_noise_timer.wait_time = crowd_reaction_timeout
	random_crowd_noise_timer.connect("timeout", _on_timer_timeout)

	add_child(random_crowd_noise_timer)
	#print("SOUND, start_crowd_timer : ", random_crowd_noise_timer.wait_time)
	#print("SOUND, time : ", Time.get_datetime_dict_from_system())


func _on_star_collected(star):
	if GameEvents.ghost_mode:
		SoundManager.play_sound_by_id(SoundManager.Sound.STAR_PICKUP, "Muffled")
	else:
		SoundManager.play_sound_by_id(SoundManager.Sound.STAR_PICKUP)

	if star.star_type == star.StarType.REQUIRED:
		required_collected += 1
		#print("STAR required_collected: ", required_collected)
	elif star.star_type == star.StarType.OPTIONAL:
		optional_collected += 1
		#print("STAR optional_collected: ", optional_collected)

	if required_collected >= required_total:
		if !GameEvents.ghost_mode:
			#print("STAR ghost mode triggered: ", optional_collected)
			GameEvents.set_ghost_mode(true)
		else:
			#print("STAR next act triggered: ", optional_collected)
			if (GameEvents.current_act < 3):
				change_level()
			else:
				end_game()


func change_level() -> void:
	GameEvents.change_act_to(GameEvents.current_act + 1)
	GameEvents.set_ghost_mode(false)


func end_game() -> void:
	GameEvents.current_act = 1
	GameEvents.ghost_mode = false
	GameEvents.death_counter = 0
	get_tree().change_scene_to_packed(MAIN_MENU)


func handle_easy_mode(is_on) -> void:
	if !is_on:
		clear_line_positions()
	elif GameEvents.ghost_mode:
		draw_player_path()


func _on_timer_timeout():
	#print("SOUND, ghost_mode : ", GameEvents.ghost_mode)
	#print("SOUND, time : ", Time.get_datetime_dict_from_system())

	if not GameEvents.ghost_mode:
		SoundManager.play_random_crowd_sound()
