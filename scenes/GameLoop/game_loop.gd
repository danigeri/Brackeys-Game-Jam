extends Node2D

#player trail
const RECORD_INTERVAL := 0.05  # 1 second
const PATH_DOT_SCENE = preload("uid://co43cv8qwqnmv")

var positions = []
var record_timer: float = 0.0

#custom cursor
var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D

#stars
var required_total: int = 0
var optional_total: int = 0
var required_collected: int = 0
var optional_collected: int = 0

#camera
@onready var ghost_camera: Camera2D = $GhostCamera

@onready var player: CharacterBody2D = $Player
#use this if line will be Line2d not Sprites
#@onready var line_2d: Line2D = $Line2D
@onready var path_dot_container: Node2D = $PathDotContainer


func _ready() -> void:
	#custom cursor
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MusicPlayer.start_music()

	#signals
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	GameEvents.easy_mode_on.connect(handle_easy_mode)

	#stars
	count_stars_palced_on_map()
	#print("ready, required_total: ", required_total)
	#print("ready, optional_total: ", optional_total)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)


func _process(delta: float) -> void:
	if !GameEvents.ghost_mode:
		record_timer += delta
		if record_timer >= RECORD_INTERVAL:
			record_timer -= RECORD_INTERVAL
			positions.append(player.global_position)


func handle_ghost_mode(is_ghost_mode) -> void:

	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)
	reset_stars()
	handle_player_path(is_ghost_mode)


func reset_stars() -> void:
	required_collected = 0
	optional_collected = 0
	for star in get_tree().get_nodes_in_group("stars"):
		star.reset_star()


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
	for star in get_tree().get_nodes_in_group("stars"):
		star.collected.connect(_on_star_collected)
		if star.star_type == star.StarType.REQUIRED:
			required_total += 1
		elif star.star_type == star.StarType.OPTIONAL:
			optional_total += 1


func _on_star_collected(star):
	if star.star_type == star.StarType.REQUIRED:
		required_collected += 1
	elif star.star_type == star.StarType.OPTIONAL:
		optional_collected += 1

	#print("ready, required_collected: ", required_collected)
	#print("ready, optional_collected: ", optional_collected)

	if required_collected >= required_total:
		GameEvents.set_ghost_mode(true)


func handle_easy_mode(is_on) -> void:
	if !is_on:
		clear_line_positions()
	elif GameEvents.ghost_mode:
		draw_player_path()
