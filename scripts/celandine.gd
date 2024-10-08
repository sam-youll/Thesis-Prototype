extends MeshInstance3D
class_name Celandine

@onready var area_3d: Area3D = $Area3D

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("area entered")
	FmodServer.play_one_shot("event:/mus_chime")


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("body entered")
	FmodServer.play_one_shot("event:/mus_chime")
