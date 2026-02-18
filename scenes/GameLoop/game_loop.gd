extends Node2D

var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D
var required_total: int = 0
var optional_total: int = 0
var required_collected: int = 0
var optional_collected: int = 0

@onready var ghost_camera: Camera2D = $GhostCamera


func _ready() -> void:
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	for star in get_tree().get_nodes_in_group("stars"):
		star.collected.connect(_on_star_collected)
		if star.star_type == star.StarType.REQUIRED:
			required_total += 1
		elif star.star_type == star.StarType.OPTIONAL:
			optional_total += 1

	#print("ready, required_total: ", required_total)
	#print("ready, optional_total: ", optional_total)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)


func handle_ghost_mode(is_ghost_mode) -> void:
	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)
	reset_stars(is_ghost_mode)


func reset_stars(is_ghost_mode) -> void:
	if is_ghost_mode:
		required_collected = 0
		optional_collected = 0
		for star in get_tree().get_nodes_in_group("stars"):
			star.reset_star()
			#print("star reset: ", star)


func use_ghost_camera(is_ghost_mode) -> void:
	if is_ghost_mode:
		ghost_camera.make_current()


func show_hide_cursor(is_ghost_mode):
	if is_ghost_mode:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Input.warp_mouse(get_viewport().get_visible_rect().size / 2)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_star_collected(star):
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
	GameEvents.ghost_mode_on.emit(true)
