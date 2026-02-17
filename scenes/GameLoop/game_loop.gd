extends Node2D

var pressed_cursor: Texture2D
var default_custom_cursor: Texture2D
var positions = []
var record_timer: float = 0.0
var ghost_mode = false
const RECORD_INTERVAL := 0.3 # 1 second

@onready var ghost_camera: Camera2D = $GhostCamera
@onready var player: CharacterBody2D = $Player
@onready var line_2d: Line2D = $Line2D

func _ready() -> void:
	pressed_cursor = preload("uid://cbdwnan67004a")
	default_custom_cursor = preload("uid://cgxm8101sybcp")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(handle_ghost_mode)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_custom_mouse_cursor(pressed_cursor)
		else:
			Input.set_custom_mouse_cursor(default_custom_cursor)

#kell majd a linehoz
#func _process(delta: float) -> void:
	#record_timer += delta
	#if record_timer >= RECORD_INTERVAL:
		#record_timer -= RECORD_INTERVAL
	#if !ghost_mode:
		#positions.append(player.global_position)

func handle_ghost_mode(is_ghost_mode) -> void:
	#print("fhost mode signal: ", is_ghost_mode)
	#ghost_mode = is_ghost_mode
	use_ghost_camera(is_ghost_mode)
	show_hide_cursor(is_ghost_mode)

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
		
