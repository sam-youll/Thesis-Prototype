extends StaticBody3D
class_name RandomTree

@export var trees = []
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mesh_instance_3d.mesh = trees[randi_range(0, trees.size()-1)]
	rotation_degrees.y = randf_range(0, 360)
	var s = randf_range(.8, 1.3)
	scale = Vector3(s, s, s)
