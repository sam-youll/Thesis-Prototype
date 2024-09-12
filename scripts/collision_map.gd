extends CollisionShape3D
class_name CollisionMap

@export var player : Node3D
@export var template_mesh : PlaneMesh
@onready var faces = template_mesh.get_faces()
@export var snap = Vector3.ONE * 4

func _ready():
	update_shape()
	
func _physics_process(_delta):
	var player_rounded_position = player.global_position.snapped(snap) * Vector3(1,0,1)
	if not global_position == player_rounded_position:
		global_position = player_rounded_position
		update_shape()
func update_shape():
	for i in faces.size():
		var global_vert = faces[i] + global_position
		faces[i].y = HeightmapManager.get_height(global_vert.x, global_vert.z)
	shape.set_faces(faces)
