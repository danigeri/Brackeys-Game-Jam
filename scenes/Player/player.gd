extends CharacterBody2D

# player movement properties
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_SPEED = 300.0
const ACCELERATION = 1200.0
const FRICTION = 1000.0

## Crowd reaction point of falling velocity of the player.
## 0-384 will trigger during a simple vertical jump
@export var crowd_sensitivity_on_falling = 450

# player input record
var records = []
var record_index: int = 0
var runtime: float = 0.0

var is_ghost_mode: bool = false
var starting_position

# button states
var left_button_is_down: bool = false
var right_button_is_down: bool = false

# coyote time + jump buffer
var jump_available: bool = true
var coyote_time: float = 0.15
var jump_buffer: bool = false
var jump_buffer_timer: float = 0.1
var is_falling: bool = false

@onready var coyote_timer: Timer = $Coyote_Timer
@onready var camera_2d: Camera2D = $Camera2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)


func _physics_process(delta: float) -> void:
	runtime += delta

	if not is_on_floor():
		if jump_available and coyote_timer.is_stopped():
			coyote_timer.start(coyote_time)

		velocity += get_gravity() * delta
	else:
		jump_available = true
		coyote_timer.stop()

		if jump_buffer:
			jump()
			jump_buffer = false

	var current_time = runtime

	if not is_ghost_mode:
		if Input.is_action_just_pressed("up"):
			_save_record(InputRecord.InputType.UP, current_time)
			_play_input(InputRecord.InputType.UP)

		if Input.is_action_just_pressed("left"):
			_save_record(InputRecord.InputType.LEFT_PRESS, current_time)
			_play_input(InputRecord.InputType.LEFT_PRESS)

		if Input.is_action_just_released("left"):
			_save_record(InputRecord.InputType.LEFT_RELEASE, current_time)
			_play_input(InputRecord.InputType.LEFT_RELEASE)

		if Input.is_action_just_pressed("right"):
			_save_record(InputRecord.InputType.RIGHT_PRESS, current_time)
			_play_input(InputRecord.InputType.RIGHT_PRESS)

		if Input.is_action_just_released("right"):
			_save_record(InputRecord.InputType.RIGHT_RELEASE, current_time)
			_play_input(InputRecord.InputType.RIGHT_RELEASE)

	else:
		while record_index < records.size():
			var current_record = records[record_index]

			if current_record.time > current_time:
				break

			_play_input(current_record.input_type)
			record_index += 1

		if not GameEvents.no_moves_left and record_index >= records.size() and records.size() > 0:
			GameEvents.no_moves_left = true
			await get_tree().create_timer(2.0).timeout  # simple timer before showing the restart overlay
			GameEvents.records_completed.emit()

	if Input.is_action_just_pressed("ghost_run"):
		GameEvents.set_ghost_mode(true)

	if Input.is_action_just_pressed("player_run"):
		GameEvents.set_ghost_mode(false)

	calculate_movement(delta)
	move_and_slide()
	play_falling_sound()


func calculate_movement(delta) -> void:
	var direction := 0

	if left_button_is_down and not right_button_is_down:
		direction = -1
	elif right_button_is_down and not left_button_is_down:
		direction = 1

	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# play corresponding player sprite
	if direction != 0:
		animated_sprite_2d.flip_h = direction < 0

	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	else:
		if velocity.y > 0:
			animated_sprite_2d.play("fall")
		else:
			animated_sprite_2d.play("jump")


func ghost_mode_on(value) -> void:
	show()
	is_ghost_mode = value

	if value:
		start_ghost_run()
		set_modulate(Color())
	else:
		start_player_run()
		camera_2d.make_current()
		set_modulate(Color(1, 1, 1, 1))


func start_ghost_run():
	reset_player_input_things()


func start_player_run():
	records.clear()
	reset_player_input_things()


func reset_player_input_things():
	runtime = 0.0
	record_index = 0
	position = starting_position
	velocity = Vector2.ZERO
	left_button_is_down = false
	right_button_is_down = false
	jump_available = true
	jump_buffer = false
	coyote_timer.stop()
	GameEvents.no_moves_left = false


func play_falling_sound():
	if not is_on_floor():
		if velocity.y > crowd_sensitivity_on_falling and not is_falling:
			if GameEvents.ghost_mode:
				SoundManager.play_sound_by_id(SoundManager.Sound.FALL_REACTION, "Muffled")
			else:
				SoundManager.play_sound_by_id(SoundManager.Sound.FALL_REACTION)
			is_falling = true
	else:
		is_falling = false


func _save_record(input: InputRecord.InputType, current_time: float) -> void:
	var input_record = InputRecord.new()
	input_record.input_type = input
	input_record.time = current_time
	records.append(input_record)


func _play_input(input: InputRecord.InputType) -> void:
	if input == InputRecord.InputType.UP:
		if jump_available:
			jump()
		else:
			jump_buffer = true
			get_tree().create_timer(jump_buffer_timer).timeout.connect(on_jump_buffer_timeout)

	elif input == InputRecord.InputType.LEFT_PRESS:
		left_button_is_down = true

	elif input == InputRecord.InputType.LEFT_RELEASE:
		left_button_is_down = false

	elif input == InputRecord.InputType.RIGHT_PRESS:
		right_button_is_down = true

	elif input == InputRecord.InputType.RIGHT_RELEASE:
		right_button_is_down = false


func coyote_timeout() -> void:
	jump_available = false


func on_jump_buffer_timeout() -> void:
	jump_buffer = false


func jump() -> void:
	velocity.y = JUMP_VELOCITY
	jump_available = false


func update_starting_position(_updated_starting_position: Vector2) -> void:
	position = _updated_starting_position
	starting_position = position
