extends CharacterBody2D

#player movement properties
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const MAX_SPEED = 300.0
const ACCELERATION = 1200.0
const FRICTION = 1000.0

#player input record
var records = []
var record_index: int = 0
var tick: int = 0
var restart_pressed_timi: int = 0
var game_started_timi: int = 0

var is_ghost_mode: bool = false
var starting_position

#button states
var left_button_is_down: bool = false
var right_button_is_down: bool = false

@onready var camera_2d: Camera2D = $Camera2D


func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	starting_position = position


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var current_timi = Time.get_ticks_usec() - restart_pressed_timi
	# Handle jump.
	if not is_ghost_mode:
		if Input.is_action_just_pressed("up") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			_save_record(InputRecord.InputType.UP, current_timi)

		if Input.is_action_just_pressed("left"):
			_save_record(InputRecord.InputType.LEFT_PRESS, current_timi)
			_play_input(InputRecord.InputType.LEFT_PRESS)
		if Input.is_action_just_released("left"):
			_save_record(InputRecord.InputType.LEFT_RELEASE, current_timi)
			_play_input(InputRecord.InputType.LEFT_RELEASE)

		if Input.is_action_just_pressed("right"):
			_save_record(InputRecord.InputType.RIGHT_PRESS, current_timi)
			_play_input(InputRecord.InputType.RIGHT_PRESS)
		if Input.is_action_just_released("right"):
			_save_record(InputRecord.InputType.RIGHT_RELEASE, current_timi)
			_play_input(InputRecord.InputType.RIGHT_RELEASE)
	else:
		for i in range(record_index, records.size()):
			var current_record = records[record_index]
			if current_record.timi <= current_timi:
				_play_input(current_record.input_type)
				record_index += 1

	if Input.is_action_just_pressed("ghost_run"):
		#print("GHOST_RUN pressed")
		GameEvents.set_ghost_mode(true)

	if Input.is_action_just_pressed("player_run"):
		#print("PLAYER_RUN pressed")
		GameEvents.set_ghost_mode(false)

	calculate_movement(delta)
	move_and_slide()


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


func ghost_mode_on(value) -> void:
	is_ghost_mode = value

	if value:
		start_ghost_run()
	else:
		start_player_run()
		camera_2d.make_current()


func start_ghost_run():
	if left_button_is_down:
		_save_record(InputRecord.InputType.LEFT_RELEASE, 0)
	if right_button_is_down:
		_save_record(InputRecord.InputType.RIGHT_RELEASE, 0)
	reset_player_input_things()


func start_player_run():
	records.clear()
	reset_player_input_things()


func reset_player_input_things():
	restart_pressed_timi = Time.get_ticks_usec()
	record_index = 0
	position = starting_position
	velocity.x = 0
	velocity.y = 0
	left_button_is_down = false
	right_button_is_down = false


func _save_record(input: InputRecord.InputType, current_timi: int) -> void:
	var input_record = InputRecord.new()
	input_record.input_type = input
	input_record.timi = current_timi
	records.append(input_record)
	#print("SAVED record: ", InputRecord.InputType.find_key(input_record.input_type),
	#      " : ", input_record.timi)


func _play_input(input: InputRecord.InputType) -> void:
	#print("USER input: ", InputRecord.InputType.find_key(input))
	if input == InputRecord.InputType.UP and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif input == InputRecord.InputType.LEFT_PRESS or input == InputRecord.InputType.LEFT_RELEASE:
		left_button_is_down = (input == InputRecord.InputType.LEFT_PRESS)
	elif input == InputRecord.InputType.RIGHT_PRESS or input == InputRecord.InputType.RIGHT_RELEASE:
		right_button_is_down = (input == InputRecord.InputType.RIGHT_PRESS)
