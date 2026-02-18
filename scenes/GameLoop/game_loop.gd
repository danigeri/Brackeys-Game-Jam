extends Node2D

@onready var ghost_camera: Camera2D = $GhostCamera

var required_total : int =  0
var optional_total : int =  0
var required_collected : int =  0
var optional_collected : int =  0

func _ready() -> void:
	print("ready")
	#MusicPlayer.start_music()
	GameEvents.ghost_mode_on.connect(ghost_mode_triggered)
	
	for star in get_tree().get_nodes_in_group("stars"):
		star.collected.connect(_on_star_collected)
		if star.star_type == star.StarType.REQUIRED:
			required_total += 1
		elif star.star_type == star.StarType.OPTIONAL:
			optional_total += 1
	
	print("ready, required_total: " , required_total)
	print("ready, optional_total: " , optional_total)

func ghost_mode_triggered(value) -> void:
	if value:
		ghost_camera.make_current()
		
	required_collected = 0
	optional_collected = 0 
	for star in get_tree().get_nodes_in_group("stars"):
		star.reset_star()
		print("star reset: " , star)
		
	print("ready, required_collected: " , required_collected)
	print("ready, optional_collected: " , optional_collected)
		
func _on_star_collected(star):
	if star.star_type == star.StarType.REQUIRED:
		required_collected += 1
	elif star.star_type == star.StarType.OPTIONAL:
		optional_collected += 1
		
	
	print("ready, required_collected: " , required_collected)
	print("ready, optional_collected: " , optional_collected)

	if required_collected >= required_total:
		call_deferred("_trigger_ghost_mode")

func _trigger_ghost_mode():
	GameEvents.ghost_mode_on.emit(true)
