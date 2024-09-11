extends PhantomCamera3D

@export var follow_point: Node3D

func _physics_process(delta: float) -> void:
	position = lerp(position, follow_point.position, .05)