extends Node2D

#player trail
const RECORD_INTERVAL := 0.3  # 1 second

@export var crowd_reaction_timeout = 30.0

var positions = []
var record_timer: float = 0.0
var ghost_mode = false

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
@onready var line_2d: Line2D = $Line2D


func _ready() -> void:
	#custom cursor
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	MusicPlayer.start_music()

	#signals
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)

	#stars
	count_stars_palced_on_map()
	#print("ready, required_total: ", required_total)
	#print("ready, optional_total: ", optional_total)
	
	start_crowd_timer()
	await SoundManager.play_sound_by_id(SoundManager.Sound.CURTAIN).finsihed


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)


#kell majd a linehoz
#func _process(delta: float) -> void:
#	record_timer += delta
#	if record_timer >= RECORD_INTERVAL:
#		record_timer -= RECORD_INTERVAL
#	if !ghost_mode:
#		positions.append(player.global_position)


func handle_ghost_mode(is_ghost_mode) -> void:
	#print("fhost mode signal: ", is_ghost_mode)
	#ghost_mode = is_ghost_mode
	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)
	reset_stars()


func reset_stars() -> void:
	required_collected = 0
	optional_collected = 0
	for star in get_tree().get_nodes_in_group("stars"):
		star.reset_star()
		#print("star reset: ", star)


func use_ghost_camera(is_ghost_mode) -> void:
	if is_ghost_mode:
		#add_position()
		ghost_camera.make_current()
	#else:
	#	line_2d.clear_points()


func clear_line_positions() -> void:
	line_2d.clear_points()


func add_position() -> void:
	for pos in positions:
		line_2d.add_point(pos)


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


func start_crowd_timer() -> void:
	var random_crowd_noise_timer := Timer.new()
	
	add_child(random_crowd_noise_timer)

	random_crowd_noise_timer.start()
	random_crowd_noise_timer.wait_time = crowd_reaction_timeout
	random_crowd_noise_timer.connect("timeout", _on_timer_timeout)


func _on_star_collected(star):
	SoundManager.play_sound_by_id(SoundManager.Sound.STAR_PICKUP)
	if star.star_type == star.StarType.REQUIRED:
		required_collected += 1
	elif star.star_type == star.StarType.OPTIONAL:
		optional_collected += 1

	#print("ready, required_collected: ", required_collected)
	#print("ready, optional_collected: ", optional_collected)

	if required_collected >= required_total:
		call_deferred("_trigger_ghost_mode")


#ez azert kell, mert idozites miatt nem rajzolodott vissza ghost mode-ban
#az utoljara felszedett star, csak az osszes tobbi
#ha van valami jobb megoldas akkor javitsuk


func _trigger_ghost_mode():
	await SoundManager.play_sound_by_id(SoundManager.Sound.CURTAIN).finsihed
	GameEvents.set_ghost_mode(true)


func _on_timer_timeout():
	SoundManager.play_random_crowd_sound()
