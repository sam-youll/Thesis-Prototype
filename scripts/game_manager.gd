@icon("res://assets/textures/node icons/manager.svg")
class_name GameManager
extends Node

@onready var pause_menu: Control = $"../PauseMenu"
var is_fullscreen: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
		if get_tree().paused:
			FmodServer.pause_all_events()
		else:
			FmodServer.unpause_all_events()
	
	if get_tree().paused:
		pause_menu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		pause_menu.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_reset_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_toggle_full_screen_toggled(toggled_on: bool) -> void:
	is_fullscreen = toggled_on
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
