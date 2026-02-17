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
var right_button_is_down: bool = false

func ghost_mode_on(value) ->void: 
	#print("GAME_LOOP : ", value)
	is_ghost_mode = value

func _ready() -> void:
	GameEvents.ghost_mode_on.connect(ghost_mode_on)
	starting_position = position

func _save_record(input: InputRecord.InputType, current_timi: int) -> void:
	var input_record = InputRecord.new()
	input_record.input_type = input
	input_record.timi = current_timi
	records.append(input_record)
	#print("SAVED record: ", InputRecord.InputType.find_key(input_record.input_type), " : ", input_record.timi)

func _play_input(input: InputRecord.InputType) -> void:
	#print("USER input: ", InputRecord.InputType.find_key(input))
	if input == InputRecord.InputType.UP and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif input == InputRecord.InputType.LEFT_PRESS or input == InputRecord.InputType.LEFT_RELEASE:
		left_button_is_down = (input == InputRecord.InputType.LEFT_PRESS)
	elif input == InputRecord.InputType.RIGHT_PRESS or input == InputRecord.InputType.RIGHT_RELEASE:
		right_button_is_down = (input == InputRecord.InputType.RIGHT_PRESS)
	

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
				record_index+=1
				
	if Input.is_action_just_pressed("ghost_run"):
		#print("GHOST_RUN pressed")
		
		restart_pressed_timi = Time.get_ticks_usec()
		GameEvents.ghost_mode_on.emit(true)
		position = starting_position
		record_index = 0 
		if left_button_is_down:
			_save_record(InputRecord.InputType.LEFT_RELEASE, current_timi)
		if right_button_is_down:
			_save_record(InputRecord.InputType.RIGHT_RELEASE, current_timi)
		left_button_is_down = false
		right_button_is_down = false
		
	if Input.is_action_just_pressed("player_run"):
		#print("PLAYER_RUN pressed")
		GameEvents.ghost_mode_on.emit(false)
		records.clear()
		record_index = 0
		restart_pressed_timi = Time.get_ticks_usec()
		position = starting_position
		velocity.x = 0
		left_button_is_down = false
		right_button_is_down = false

	if left_button_is_down and not right_button_is_down:
		velocity.x = -1 * SPEED
	elif right_button_is_down and not left_button_is_down:
		velocity.x = 1 * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
