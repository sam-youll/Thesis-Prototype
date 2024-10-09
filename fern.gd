extends Node3D
class_name Fern

func _on_area_3d_body_entered(body: Node3D) -> void:
	FmodServer.play_one_shot("event:/mus_chime")
