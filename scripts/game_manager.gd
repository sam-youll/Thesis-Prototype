@icon("res://assets/textures/node icons/manager.svg")
class_name GameManager
extends Node

@onready var pause_menu: Control = $"../PauseMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = !get_tree().paused
	
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
