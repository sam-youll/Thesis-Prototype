extends StaticBody3D
class_name DeformableTerrain

@export var mesh_mat: ShaderMaterial
@export var player: PlayerCharacter
@export var template_mesh: PlaneMesh
@export_range(.1, 10) var height_scale: float = 1
@export_range(4, 20) var diameter: int = 4

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var coll: CollisionShape3D = $CollisionShape3D
@onready var faces := template_mesh.get_faces()

var array_mesh: ArrayMesh
var heightmap := []
var update_map := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_heightmap()
	update_shape()
	mesh.set_deformable_mesh(heightmap)
	
	
func _physics_process(_delta: float) -> void:
	pass
#	if Input.is_action_pressed("draw"):
#		update_heightmap()
#		mesh.update_deformable_mesh(update_map, Vector2(player.pos_x, player.pos_z))

func init_heightmap() -> void:
	for i in 512:
		heightmap.append([])
		for j in 512:
			heightmap[i].append(sin(i * .2) * cos(j * .2) * height_scale)
#			heightmap[i].append(1 * height_scale)
			
func update_heightmap() -> void:
	var radius := int(float(diameter) / 2)
	update_map.clear()
	for x in diameter:
		update_map.append([])
		for z in diameter:
			var hx := player.pos_x - radius
			var hz := player.pos_z - radius
			var dist_scale := (Vector2(player.pos_x, player.pos_z) - Vector2(hx, hz)).length()
			heightmap[hx][hz] += player.volume * dist_scale * .01
			update_map[x].append(heightmap[hx][hz])
	
func update_shape() -> void:
	for i in faces.size():
		faces[i].y = heightmap[(faces[i].x + 128) * 2 - 1][(faces[i].z + 128) * 2 - 1]
	coll.shape.set_faces(faces)

