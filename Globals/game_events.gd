extends Node

signal menu_back_pressed
signal ghost_mode_on(value: bool)
signal easy_mode_on(value: bool)

var ghost_mode: bool = false
var easy_mode: bool = false


func show_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.warp_mouse(get_viewport().get_visible_rect().size / 2)


func update_cursor() -> void:
	if ghost_mode:
		show_cursor()
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


#ez azert kell, mert idozites miatt nem rajzolodott vissza ghost mode-ban
#az utoljara felszedett star, csak az osszes tobbi
#ha van valami jobb megoldas akkor javitsuk


func _set_ghost_mode(is_on: bool) -> void:
	ghost_mode = is_on
	ghost_mode_on.emit(is_on)

func set_ghost_mode(is_on: bool) -> void:
	call_deferred("_set_ghost_mode", is_on)

func set_easy_mode_on(is_on: bool) -> void:
	easy_mode = is_on
	easy_mode_on.emit(is_on)
