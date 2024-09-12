extends Node

var heightmap_tex: Texture2D
var heightmap_img: Image
var radius: int = 6
const BLACK_SQUARE = preload("res://assets/black square.png")
var pos_x
var pos_z
var volume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	heightmap_tex = BLACK_SQUARE
	heightmap_img = BLACK_SQUARE.get_image()

func _physics_process(delta: float) -> void:
	if pos_x != null:
		update_heightmap()

func init_heightmap() -> void:
	heightmap_img = Image.new()
	heightmap_img.create_empty(512, 512, false, Image.FORMAT_L8)
	print(heightmap_img.get_width())
	for x in 512:
		for y in 512:
			heightmap_img.set_pixel(x, y, Color(0, 0, 0))
			
func update_heightmap() -> void:
	var remapped_x: int = floor(remap(pos_x, -128, 128, 0, 512))
	var remapped_z: int = floor(remap(pos_z, -128, 128, 0, 512))
	for x in radius * 2:
		for z in radius * 2:
			var mx := remapped_x + x - radius
			var mz := remapped_z + z - radius
			var dist: float = (Vector2(remapped_x, remapped_z) - Vector2(mx, mz)).length() / radius
			var col_val: float = volume * dist
			var col: Color = Color(col_val, col_val, col_val)
			heightmap_tex.set_pixel(mx, mz, col)
	RenderingServer.global_shader_parameter_set("heightmap", heightmap_tex)

func get_height(x, z) -> float:
	var size = heightmap_img.get_width()
	var amplitude : float = ProjectSettings.get_setting("shader_globals/amplitude").value
	return heightmap_img.get_pixel(fposmod(x,size), fposmod(z,size)).r * amplitude
