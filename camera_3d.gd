extends Camera3D

@onready var player_character: CharacterBody3D
var cam_target
@export var cam_lerp_speed := .1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_character = get_parent().get_parent()
	cam_target = player_character.get_child(0)
	print(cam_target)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position = position.lerp(cam_target.global_position, cam_lerp_speed)
	look_at(player_character.global_position)
