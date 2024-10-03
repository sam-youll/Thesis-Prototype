extends PhantomCamera3D

var min_yaw: float = 0
var max_yaw: float = 360

var min_pitch: float = -89.9
var max_pitch: float = 50

@export var sensitivity: float = .5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rot = get_third_person_rotation()
		rot.x -= event.relative.x * sensitivity
		rot.x = clampf(rot.x, min_pitch, max_pitch)
		rot.y -= event.relative.y * sensitivity
		rot.y = clampf(rot.y, min_yaw, max_yaw)
		set_third_person_rotation(rot)
		
	
