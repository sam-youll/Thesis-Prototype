extends StaticBody3D
class_name MusicTerrain

@export var player: PlayerCharacter
@export var minimap: ColorRect
@export_range(2, 24) var radius: int = 6
@export_range(10, 40) var amplitude: int = 10
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
var mesh_mat: ShaderMaterial
var heightmap_img: Image
var heightmap_tex: Texture2D

# COLLISION MAP
@export_group("Collision Map")
@onready var coll: CollisionShape3D = $CollisionMap
@export var template_mesh : PlaneMesh
@onready var faces = template_mesh.get_faces()
@export var snap = Vector3.ONE * 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	init_heightmap()
	mesh_mat = mesh_instance.mesh.surface_get_material(0)
	mesh_mat.set_shader_parameter("amplitude", amplitude)

func _physics_process(delta: float) -> void: 
	if player.pos_x != null:
		update_heightmap()
		var img := ImageTexture.create_from_image(heightmap_img)
		mesh_mat.set_shader_parameter("heightmap", img)
		minimap.material["shader_parameter/display_img"] = img
		
	var player_rounded_position = player.global_position.snapped(snap) * Vector3(1,0,1)
	if coll.global_position != player_rounded_position:
		coll.global_position = player_rounded_position
	update_shape()

func init_heightmap() -> void:
	heightmap_img = Image.create_empty(512, 512, false, Image.FORMAT_L8)
	print(heightmap_img.get_width())
	for x in 512:
		for y in 512:
			heightmap_img.set_pixel(x, y, Color(0, 0, 0))
			
func update_heightmap() -> void:
	for x in radius * 2:
		for z in radius * 2:
			var mx: int = player.pos_x + x - radius
			var mz: int = player.pos_z + z - radius
			if mx < 0 or mx > 511 or mz < 0 or mz > 511:
				continue
			var height: float = get_height(mx, mz)
			if height >= 1:
				continue
			var dist: float = (radius - clamp(((Vector2(player.pos_x, player.pos_z) - Vector2(mx, mz)).length()), 0, radius)) / radius
			var col_val: float = player.volume * dist * .005 + height
			col_val = clamp(col_val, 0, 1)
			var col: Color = Color(col_val, col_val, col_val)
			heightmap_img.set_pixel(mx, mz, col)

func get_height(x, z) -> float:
	var size = heightmap_img.get_width()
	return heightmap_img.get_pixel(fposmod(x,size), fposmod(z,size)).r
	
func update_shape():
	for i in faces.size():
		var global_vert = faces[i] + Vector3(player.pos_x, 0, player.pos_z)
		print(global_vert)
		faces[i].y = get_height(global_vert.x, global_vert.z) * amplitude
	coll.shape.set_faces(faces)
