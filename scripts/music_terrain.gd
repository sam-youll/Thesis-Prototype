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
var is_terrain_deform_on: bool = false
@export var map_width: int = 64
@export var map_height: int = 1024
@export var map_scale: float = .5 # (e.g. 512 x 512 @ .5 scale -> 256m x 256m in-game)
@export var noise_tex: NoiseTexture2D

# COLLISION MAP
@export_group("Collision Map")
@onready var coll: CollisionShape3D = $CollisionMap
@export var template_mesh : PlaneMesh
@onready var faces = template_mesh.get_faces()
@export var snap = Vector3.ONE * 2

# SPAWNING
@export_group("Spawning")
@export var celandine_tscn: PackedScene
@export var fern_tscn: PackedScene
var celandine_img: Image # this image records locations of celandine

#fmod oneshot variable
var chime: FmodEvent = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#player.position = Vector3(0, 10, 0)
	init_heightmap()
	init_celandine_img()
	mesh_mat = mesh_instance.mesh.surface_get_material(0)
	mesh_mat.set_shader_parameter("amplitude", amplitude)
	if is_terrain_deform_on:
		update_shape()
	update_shape()
	
	#fmod event initialize
	chime = FmodServer.create_event_instance("event:/mus_chime")
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("toggle_terrain_deform"):
		is_terrain_deform_on = !is_terrain_deform_on
		print(is_terrain_deform_on)
		
	if Input.is_action_just_pressed("spawn_celandine") && player.state != 2:
		spawn_celandine()
	if Input.is_action_just_pressed("spawn_fern") && player.state != 2:
		spawn_fern()

func _physics_process(delta: float) -> void: 
	if player.pos_x != null:
		if is_terrain_deform_on:
			update_heightmap()
		var img := ImageTexture.create_from_image(heightmap_img)
		mesh_mat.set_shader_parameter("heightmap", img)
		minimap.material["shader_parameter/display_img"] = img
		
	var player_rounded_position = player.global_position.snapped(snap) * Vector3(1,0,1)
	if coll.global_position != player_rounded_position:
		coll.global_position = player_rounded_position
	update_shape()

func init_heightmap() -> void:
	var noise_img = FastNoiseLite.new().get_seamless_image(map_width, map_height)
	#var noise_img = noise_tex.get_seamless_image(map_width, map_height)
	heightmap_img = Image.create_empty(map_width, map_height, false, Image.FORMAT_L8)
	for x in map_width:
		for y in map_height:
			#var val = .1*cos(x * .2)*sin(y * .2) + .1
			var val = noise_img.get_pixel(x, y).r * .5
			#var val = (pow(x - 32, 2)) / (32 * 32)
			#var val = 0
			var col = Color(val, val, val)
			heightmap_img.set_pixel(x, y, col)
			
func update_heightmap() -> void:
	var player_pos = Vector2(player.pos_x, player.pos_z)
	for x in radius * 2:
		for z in radius * 2:
			var mx: int = player.pos_x + x - radius
			var mz: int = player.pos_z + z - radius
			#if mx < 0 or mx > 511 or mz < 0 or mz > 511:
				#continue
			if mx < 0:
				mx += map_width
			if mx >= map_width:
				mx -= map_width
			if mz < 0:
				mz += map_height
			if mz >= map_height:
				mz -= map_height
			var height: float = get_height(mx, mz)
			if height >= 1:
				continue
			#var dist: float = (radius - clamp(((Vector2(player.pos_x, player.pos_z) - Vector2(mx, mz)).length()), 0, radius)) / radius
			var dist: float = (player_pos - Vector2(mx, mz)).length()
			dist = remap(dist, 0, radius, 1, 0)
			dist = clamp(dist, 0, 1)
			var col_val: float = player.speed_param * dist * .005 + height
			col_val = clamp(col_val, 0, 1)
			var col: Color = Color(col_val, col_val, col_val)
			heightmap_img.set_pixel(mx, mz, col)
			
			#if x == radius && z == radius:
				#print("set height at player to " + str(col_val))

func get_height(x, z) -> float:
	#var size = heightmap_img.get_width()
	#return heightmap_img.get_pixel(fposmod(x,size), fposmod(z,size)).r
	#print("(" + str(x) + ", " + str(z) + ") = " + str(heightmap_img.get_pixel(x, z).r))
	return heightmap_img.get_pixel(x, z).r
	
func update_shape():
	var offset = 0
	for i in faces.size():
		var global_vert = 2 * (faces[i] + coll.global_position + Vector3(map_width * map_scale * .5, 0, map_height * map_scale * .5))
		if global_vert.x >= map_width:
			global_vert.x -= map_width
		elif global_vert.x < 0:
			global_vert.x += map_width
		elif global_vert.z >= map_height:
			global_vert.z -= map_height
		elif global_vert.z < 0:
			global_vert.z += map_height
		faces[i].y = get_height((global_vert.x + offset), (global_vert.z) + offset) * amplitude
	coll.shape.set_faces(faces)
	#var img = heightmap_img.get_region(Rect2i(Vector2(player.pos_x - 3, player.pos_z + 3), Vector2(6, 6)))
	##img.resize(3, 3, Image.INTERPOLATE_BILINEAR)
	#print(player.pos_x)
	#coll.shape.update_map_data_from_image(img, 0, amplitude)

func init_celandine_img() -> void:
	celandine_img = Image.create_empty(map_width, map_height, false, Image.FORMAT_L8)

func spawn_celandine() -> void:
	#sound trigger
	FmodServer.play_one_shot("event:/mus_chime")
	
	celandine_img.set_pixel(player.pos_x, player.pos_z, Color.GREEN)
	var new_cel = celandine_tscn.instantiate()
	add_child(new_cel)
	new_cel.basis = player.basis.rotated(Vector3.UP, randf() * PI * 2)
	var randx = randf_range(-1, 1)
	var randz = randf_range(-1 ,1)
	var pos = Vector3(player.global_position.x + randx * .5, get_height(player.pos_x + randx, player.pos_z + randz) * amplitude, player.global_position.z + randz * .5)
	new_cel.global_position = pos
	var my_scale = randf() + 1.5
	new_cel.basis = new_cel.basis.scaled(Vector3(my_scale, my_scale, my_scale))

func spawn_fern() -> void:
	#sound trigger
	FmodServer.play_one_shot("event:/mus_chime")
	
	celandine_img.set_pixel(player.pos_x, player.pos_z, Color.GREEN)
	var new_fern = fern_tscn.instantiate()
	add_child(new_fern)
	new_fern.basis = player.basis.rotated(Vector3.UP, randf() * PI * 2)
	var randx = randf_range(-1, 1)
	var randz = randf_range(-1 ,1)
	var pos = Vector3(player.global_position.x + randx * .5, get_height(player.pos_x + randx, player.pos_z + randz) * amplitude, player.global_position.z + randz * .5)
	new_fern.global_position = pos
	var my_scale = randf() + 1.5
	new_fern.basis = new_fern.basis.scaled(Vector3(my_scale, my_scale, my_scale))
