extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var records = []
var record_index : int = 0
var tick: int = 0
var restart_pressed_timi: int = 0
var game_started_timi: int = 0
var is_ghost_mode: bool = false

var starting_position

var left_button_is_down: bool = false

func _ready() -> void:
	starting_position = position

func _save_record(input: InputRecord.InputType, current_timi: int) -> void:
	var input_record = InputRecord.new()
	input_record.input_type = input
	input_record.timi = current_timi
	records.append(input_record)
	print("saved record: ", input_record.input_type, " : ", input_record.timi)

func _play_input(input: InputRecord.InputType) -> void:
	print("input: ", input)
	if input == InputRecord.InputType.UP and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif input == InputRecord.InputType.LEFT_PRESS or input == InputRecord.InputType.LEFT_RELEASE:
		left_button_is_down = (input == InputRecord.InputType.LEFT_PRESS)
	

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
			_save_record(InputRecord.InputType.RIGHT, current_timi)
	else:
		for i in range(record_index, records.size()):
			var current_record = records[record_index]
			if current_record.timi <= current_timi:
				_play_input(current_record.input_type)
				record_index+=1
				
	if Input.is_action_just_pressed("restart"):
		restart_pressed_timi = current_timi
		is_ghost_mode = true
		position = starting_position
		# player to begining

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if left_button_is_down:
		velocity.x = -1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
