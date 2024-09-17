extends StaticBody3D
class_name MusicTerrain

@export var player: PlayerCharacter
@export_range(2, 24) var radius: int = 6
var heightmap_img: ImageTexture
var heightmap_tex: Texture2D

#func _ready() -> void:
	#heightmap.create_empty(512, 512, false, 0)

#func _physics_process(_delta: float) -> void:
	#update_heightmap()

#func init_heightmap() -> void:
	#heightmap_img = Image.new()
	#heightmap_img.create_empty(512, 512, false, Image.FORMAT_L8)
	#print(heightmap_img.get_width())
	#for x in 512:
		#for y in 512:
			#heightmap_img.set_pixel(x, y, Color(0, 0, 0))

#func update_heightmap() -> void:
	#var remapped_x: int = floor(remap(player.pos_x, -128, 128, 0, 512))
	#var remapped_z: int = floor(remap(player.pos_z, -128, 128, 0, 512))
	#for x in radius * 2:
		#for z in radius * 2:
			#var mx := remapped_x + x - radius
			#var mz := remapped_z + z - radius
			#var dist: float = (Vector2(remapped_x, remapped_z) - Vector2(mx, mz)).length() / radius
			#var col_val: float = player.volume * dist
			#var col: Color = Color(col_val, col_val, col_val)
			#heightmap.set_pixel(mx, mz, col)
	#RenderingServer.global_shader_parameter_set("heightmap", heightmap)
